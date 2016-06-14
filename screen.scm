(define-record-type <screen>
  (make-screen id x y w h root display mwins stack)
  screen?
  (id screen-id)
  (x screen-x set-screen-x!)
  (y screen-y set-screen-y!)
  (w screen-w set-screen-w!)
  (h screen-h set-screen-h!)
  (root screen-root)
  (display screen-display)
  (mwins screen-mwins-obj set-screen-mwins-obj!)
  (stack screen-stack-obj set-screen-stack-obj!))

(define *screens* (vector))
(define *current-screen-index* 0)

(define (current-screen) (vector-ref *screens* *current-screen-index*))

(define mk-screen-mwins list)
(define mk-screen-stack list)
(define screen-mwins-list screen-mwins-obj)
(define screen-stack-list screen-stack-obj)

(define (screen-mwins-add! x s)
  (set-screen-mwins-obj! s (cons x (screen-mwins-obj s))))

(define (screen-mwins-rm! x s)
  (set-screen-mwins-obj! s (remove x (screen-mwins-obj s))))

(define (screen-stack-add! x s)
  (set-screen-stack-obj! s (cons x (screen-stack-obj s))))

(define (screen-stack-rm! x s)
  (set-screen-stack-obj! s (remove x (screen-stack-obj s))))

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
                              (mk-screen-mwins)
                              (mk-screen-stack))))
    (x-change-property-atoms dpy
                             root
                             (xatom "_NET_SUPPORTED")
                             (list (xatom "_NET_SUPPORTED")
                                   (xatom "_NET_WM_NAME")
                                   (xatom "_NET_WM_STATE")
                                   (xatom "_NET_WM_STATE_FULLSCREEN")))
    (x-change-window-attributes dpy root event-mask: +root-event-mask+)
    (x-select-input dpy root +root-event-mask+)
    screen))

(define (init-all-screens dpy)
  (let ((num (x-screen-count dpy)))
    (set! *screens* (make-vector num))
    (do ((i 0 (+ i 1)))
        ((>= i num))
      (vector-set! *screens* i (init-screen dpy i)))))

(define (find-screen parent)
  (find-in-vector (lambda (s) (eq? (screen-root s) parent)) *screens*))

(define (find-mwin-on-screen window screen)
  (find-if (lambda (c) (eq? (mwin-window c) window))
           (screen-mwins-list screen)))

(define (find-mwin window)
  (let loop ((i 0))
    (if (< i (vector-length *screens*))
        (or (find-mwin-on-screen window (vector-ref *screens* i))
            (loop (+ i 1)))
        #f)))

(define (pickup-windows dpy)
  (define (pickup win screen)
    (let ((wa (x-get-window-attributes dpy win)))
      (if (and (not (= win x#+none+))
               (not (x-window-attributes-override-redirect? wa))
               (or (= (x-window-attributes-map-state wa) x#+is-viewable+)
                   (= (x-get-window-property dpy win (xatom "_NET_WM_STATE"))
                      x#+iconic-state+)))
          (manage-mwin win (make-mwin win wa screen)))))
  
  (do ((i 0 (+ i 1)))
      ((>= i (vector-length *screens*)))
    (let ((wins (x-query-tree dpy (screen-root (vector-ref *screens* i)))))
      (do ((j 0 (+ j 1)))
          ((>= j (u32vector-length wins)))
        (let ((win (u32vector-ref wins j)))
          (if (not (= win x#+none+))
              (pickup win (vector-ref *screens* i))))))))
