(define-record-type screen
  (make-screen id x y w h root display view clients stack)
  screen?
  (id screen-id)
  (x screen-x set-screen-x!)
  (y screen-y set-screen-y!)
  (w screen-w set-screen-w!)
  (h screen-h set-screen-h!)
  (root screen-root)
  (display screen-display)
  (clients screen-clients set-screen-clients!)
  (stack screen-stack set-screen-stack!)
  (view screen-view set-screen-view!))

(define *screens* (vector))
(define *current-screen-index* 0)

(define (current-screen)
  (vector-ref *screens* *current-screen-index*))

(define (current-tag) (screen-view (current-screen)))

(define +root-event-mask+ (bitwise-ior x#+substructure-redirect-mask+
                                       x#+substructure-notify-mask+
                                       x#+button-press-mask+
                                       x#+enter-window-mask+
                                       x#+leave-window-mask+
                                       x#+structure-notify-mask+))

(define (init-screen dpy i)
  (let* ((root (x-root-window dpy i))
         (screen (make-screen i
                              0
                              0
                              (x-display-width dpy i)
                              (x-display-height dpy i)
                              root
                              dpy
                              (initial-view)
                              '()
                              '())))
    (x-change-property-atoms dpy
                             root
                             (xatom "_NET_SUPPORTED")
                             (list (xatom "_NET_SUPPORTED")
                                   (xatom "_NET_WM_NAME")))
    (x-change-window-attributes dpy root event-mask: +root-event-mask+)
    (x-select-input dpy root +root-event-mask+)
    screen))

(define (init-all-screens!)
  (let ((num (x-screen-count (current-display))))
    (set! *screens* (make-vector num))
    (do ((i 0 (+ i 1)))
        ((>= i num))
      (vector-set! *screens* i (init-screen (current-display) i)))))

(define (find-in-vector test v)
  (let loop ((i 0))
    (if (< i (vector-length v))
        (if (test (vector-ref v i))
            (vector-ref v i)
            (loop (+ i 1)))
        #f)))

(define (find-screen parent)
  (find-in-vector (lambda (s) (eq? (screen-root s) parent)) *screens*))

(define (find-client-on-screen window screen)
  (find-if (lambda (c) (eq? (client-window c) window)) (clients-list screen)))

(define (find-client window)
  (let loop ((i 0))
    (if (< i (vector-length *screens*))
        (or (find-client-on-screen window (vector-ref *screens* i))
            (loop (+ i 1)))
        #f)))

(define (pickup-windows!)
  (do ((i 0 (+ i 1)))
      ((>= i (vector-length *screens*)))
    (for-each
      (lambda (w)
        (if (not (= w x#+none+))
            (pickup-window (current-display) (vector-ref *screens* i) w)))
      (x-query-tree (current-display)
                    (screen-root (vector-ref *screens* i))))))
