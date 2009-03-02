(include "xlib/Xlib#.scm")
(include "utils.scm")

(define-hook *internal-startup-hook*)
(define-hook *internal-loop-hook*)
(define-hook *shutdown-hook*)

(include "screen.scm")
(include "events.scm")

(define (display-log . args)
  (display (cons ";; " args) (current-error-port))
  (newline (current-error-port)))

(define (handle-x11-event xdisplay ev)
  (display-log "Caught event type: " (x-any-event-type ev)
							 " data: " ev)
  (let ((handler (table-ref *x11-event-dispatcher* (x-any-event-type ev) #f)))
    (if handler
        (apply handler ev))))

(define (x11-event-hook xdisplay)
  (display-log "Waiting for x11 events.")
  (wait-x11-event xdisplay)
  (display-log "Got x11 events.")
  (let loop ((num (x-pending xdisplay)))
    (display-log "Has " num " events in queue.")
    (cond ((positive? num)
           (handle-x11-event xdisplay (x-next-event xdisplay))
           (loop (- num 1))))))

(add-to-list *internal-loop-hook* (lambda (dpy) (x11-event-hook dpy)))

(define (main-loop xdisplay)
  (run-hook *internal-loop-hook* xdisplay)
  (main-loop xdisplay))

(define (uwm . args)
  (let ((xdisplay-name (if (and (pair? args) (string? (car args))) 
                           (car args)
                           #f))
        (xdisplay #f))
    (dynamic-wind 
      (lambda () 
        (set! xdisplay (x-open-display xdisplay-name))
        (if (not xdisplay)
            (error "Unable to open display"))
        (run-hook *internal-startup-hook* xdisplay))
      (lambda () 
        (x-sync xdisplay #f)
        (main-loop xdisplay))
      (lambda ()
        (if xdisplay
            (run-hook *shutdown-hook* xdisplay))))))

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

