(include "xlib/Xlib#.scm")
(include "utils.scm")

(define-hook *internal-startup-hook*)
(define-hook *internal-loop-hook*)
(define-hook *shutdown-hook*)
(define-hook *manage-hook*)
(define-hook *unmanage-hook*)
(define-hook *arrange-hook*)
(define-hook *focus-hook*)
(define-hook *keypress-hook*)
(define-hook *retag-hook*)
(define-hook *rules-hook*)

(define *selected* #f)
(define *current-view* "first")
(define *user-config-file* "~/.uwm.scm")
(define *atoms* (make-table))
(define *main-mutex* (make-mutex))

(include "screen.scm")
(include "client.scm")
(include "events.scm")
(include "tile.scm")
(include "client-ops.scm")
(include "keymaps.scm")
(include "bindings.scm")
(include "variables.scm")

(define (uwm-error-handler display ev)
  (let ((error-code (char->integer (x-error-event-error-code ev)))
        (request-code (char->integer (x-error-event-request-code ev))))
    (display-log "X11 ERROR: code=" error-code " request-code=" request-code)
    (unless (or (= error-code +bad-window+)
                (and (= error-code +bad-match+)
                     (member request-code (list +x-set-input-focus+
                                                +x-configure-window+)))
                (and (= error-code +bad-drawable+)
                     (member request-code (list +x-poly-text8+
                                                +x-poly-fill-rectangle+
                                                +x-poly-segment+
                                                +x-copy-area+)))
                (and (= error-code +bad-access+)
                     (member request-code (list +x-grab-button+
                                                +x-grab-key+))))
      (default-error-handler display ev))))

(define (init-atom display name)
  (table-set! *atoms* name (x-intern-atom display name 0)))

(define (get-atom name)
  (table-ref *atoms* name #f))

(define (init-atoms display)
  (init-atom display "WM_STATE")
  (init-atom display "_NET_SUPPORTED")
  (init-atom display "_NET_WM_NAME")
  (init-atom display "WM_DELETE_WINDOW")
  (init-atom display "WM_PROTOCOLS"))

(define (init-error-handler display)
  (set-x-error-handler! uwm-error-handler))

(define (pickup-windows display)
  (for-each
    (lambda (screen)
      (for-each (lambda (window) (pickup-window display screen window))
                (x-query-tree display (screen-root screen))))
    *screens*))

(define (handle-x11-event xdisplay ev)
  (let ((handler (table-ref *x11-event-dispatcher* (x-any-event-type ev) #f)))
    (if handler
        (handler ev)
        (display-log ";; unhandled event " (x-any-event-type ev)))))

(define (x11-event-hook xdisplay)
  ;(display-log "Waiting for x11 events.")
  (call-with-x11-events
    xdisplay
    (lambda ()
      (let loop ()
        ;(display-log "Events count: " (x-pending xdisplay))
        (when (positive? (x-pending xdisplay))
          (handle-x11-event xdisplay (x-next-event xdisplay))
          (loop)))
      (let loop ()
        (let ((fn (thread-receive 0 #f)))
          (when fn
            (fn)
            (loop))))
      #t)))

(define (main-loop xdisplay)
  (run-hook *internal-loop-hook* xdisplay)
  (main-loop xdisplay))

(define (uwm . args)
  (let ((display-name (if (and (pair? args) (string? (car args)))
                           (car args)
                           #f))
        (display #f))
    (dynamic-wind
      (lambda ()
        (set! display (x-open-display display-name))
        (if (not display)
            (error (string-append "Unable to open display "
                                  (object->string display-name))))
        (run-hook *internal-startup-hook* display))
      (lambda ()
        (x-sync display #f)
        (main-loop display))
      (lambda ()
        (if display
            (run-hook *shutdown-hook* display))))))

(define (get-option option args)
  (if (pair? args)
      (if (string=? option (car args))
          (if (pair? (cdr args))
              (cadr args)
              #f)
          (get-option option (cddr args)))
      #f))

(define (load-user-config display)
  (if (file-exists? *user-config-file*)
      (load *user-config-file*)))

(define (main . args)
  (uwm (or (get-option "-d" args) (getenv "DISPLAY" #f))))

(set! *internal-startup-hook* '(init-atoms
                                init-error-handler
                                load-user-config
                                init-screens
                                setup-bindings
                                pickup-windows))
(set! *internal-loop-hook* '(x11-event-hook))

