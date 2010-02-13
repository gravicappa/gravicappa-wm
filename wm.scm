(include "define-structure.scm")
(include "xlib/xlib#.scm")
(include "utils.scm")

(define *startup-hook* (make-hook)) ; (lambda (display))
(define *shutdown-hook* (make-hook)) ; (lambda (display))

(define *manage-hook* (make-hook)) ; (lambda (display window window-attrib screen))
(define *unmanage-hook* (make-hook)) ; (lambda (client))

(define *update-tag-hook* (make-hook)) ; (lambda ())
(define *rules-hook* (make-hook)) ; (lambda (client))

(define (current-client) #f)
(define *atoms* (make-table))

(include "screen.scm")
(include "client.scm")
(include "events.scm")
(include "tile.scm")
(include "client-ops.scm")
(include "keymaps.scm")
(include "bindings.scm")
(include "variables.scm")

(define (wm-error-handler disp ev)
  (let ((error-code (char->integer (x-error-event-error-code ev)))
        (request-code (char->integer (x-error-event-request-code ev))))
    (display-log "X11 ERROR: code=" error-code " request-code=" request-code)
    (if (not (or (= error-code +bad-window+)
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
                                                 +x-grab-key+)))))
        (x-default-error-handler disp ev))))

(define (init-atom disp name)
  (table-set! *atoms* name (x-intern-atom disp name 0)))

(define (get-atom name)
  (table-ref *atoms* name #f))

(define (init-atoms disp)
  (for-each (lambda (a) (init-atom disp a))
            '("WM_STATE"
              "WM_DELETE_WINDOW"
              "WM_PROTOCOLS"
              "_NET_WM_NAME"
              "_NET_SUPPORTED")))

(define (init-error-handler disp)
  (set-x-error-handler! wm-error-handler))

(define (pickup-windows disp)
  (for-each
    (lambda (screen)
      (for-each (lambda (window) (pickup-window disp screen window))
                (x-query-tree disp (screen-root screen))))
    *screens*))

(define (handle-x11-event ev)
  (let ((proc (table-ref *x11-event-dispatcher* (x-any-event-type ev) #f)))
    (if proc
        (proc ev)
        #f #;(display-log ";; unhandled event " (x-any-event-type ev)))))

(define (process-x11-events disp)
  ;(display-log "Waiting for x11 events.")
  (x-call-with-x11-events
    disp
    (lambda ()
      (let loop ()
        ;(display-log "Events count: " (x-pending disp))
        (if (positive? (x-pending disp))
            (begin
              (handle-x11-event (x-next-event disp))
              (loop))))
      (let loop ()
        (let ((thunk (thread-receive 0 #f)))
          (if (procedure? thunk)
              (begin
                (thunk)
                (loop)))))
      (##gc)
      #t)))

(define (main-loop disp)
  (process-x11-events disp)
  (main-loop disp))

(define (load-user-config disp)
  (if (file-exists? *user-config-file*)
      (load *user-config-file*)))

(define (start-wm . args)
  (let ((display-name (if (and (pair? args) (string? (car args)))
                          (car args)
                          #f))
        (disp #f))
    (dynamic-wind
      (lambda ()
        (set! disp (x-open-display display-name))
        (if (not disp)
            (error (string-append "Unable to open display "
                                  (object->string display-name))))
        (for-each
          (lambda (proc) (proc disp))
          (list init-atoms
                init-error-handler
                init-all-screens
                load-user-config
                setup-bindings
                pickup-windows))
        (run-hook *startup-hook* disp))
      (lambda ()
        (x-sync disp #f)
        (main-loop disp))
      (lambda ()
        (if disp
            (begin
              (run-hook *shutdown-hook* disp)))
        (set! *screens* '())
        (##gc)))))

(define (get-option option args)
  (if (pair? args)
      (if (string=? option (car args))
          (if (pair? (cdr args))
              (cadr args)
              #f)
          (get-option option (cddr args)))
      #f))

(define (main . args)
  (start-wm (or (get-option "-d" args) (getenv "DISPLAY" #f))))
