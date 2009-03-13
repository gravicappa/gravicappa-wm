(include "xlib/Xlib#.scm")
(include "utils.scm")

(define *selected* #f)

(define-hook *internal-startup-hook*)
(define-hook *internal-loop-hook*)
(define-hook *shutdown-hook*)
(define-hook *manage-hook*)
(define-hook *unmanage-hook*)
(define-hook *arrange-hook*)
(define-hook *focus-hook*)

(include "screen.scm")
(include "client.scm")
(include "events.scm")
(include "tile.scm")

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

(define (init-atoms display)
  (display-log "Initializing atoms")
  (set! +wm-state+ (x-intern-atom display "WM_STATE" 0)))

(define (init-error-handler display)
  (set-x-error-handler! uwm-error-handler))

(define (collect-windows display screen)
  (let ((windows '()))
    (x-query-tree display
                  (screen-root screen)
                  (lambda (w) (push w windows)))
    (reverse windows)))

(define (pickup-windows display)
  (for-each
    (lambda (screen)
      (let ((wins (collect-windows display screen)))
        (for-each (lambda (window) (pickup-window display screen window))
                  wins)))
    *screens*))

(add-hook *internal-startup-hook* 'init-atoms)
(add-hook *internal-startup-hook* 'init-error-handler)
(add-hook *internal-startup-hook* 'pickup-windows)

(define (handle-x11-event xdisplay ev)
  (let ((handler (table-ref *x11-event-dispatcher* (x-any-event-type ev) #f)))
    (if handler
        (handler ev))))

(define (x11-event-hook xdisplay)
  (display-log "Waiting for x11 events.")
  (call-with-x11-events
    xdisplay
    (lambda ()
      (let loop ()
        (display-log "Events count: " (x-pending xdisplay))
        (when (positive? (x-pending xdisplay))
          (handle-x11-event xdisplay (x-next-event xdisplay))
          (loop)))
      #t)))

(add-hook *internal-loop-hook* 'x11-event-hook)

(define (main-loop xdisplay)
  (run-hook *internal-loop-hook* xdisplay)
  (main-loop xdisplay))

(define (uwm . args)
  (let ((xdisplay-name (if (and (pair? args) (string? (car args)))
                           (car args)
                           #f))
        (display #f))
    (dynamic-wind
      (lambda ()
        (set! display (x-open-display xdisplay-name))
        (if (not display)
            (error "Unable to open display"))
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

(define (main . args)
  (uwm (or (get-option "-d" args) (getenv "DISPLAY" #f))))

