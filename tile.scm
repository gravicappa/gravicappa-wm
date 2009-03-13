(define *frame-color-normal* #x331100)
(define *frame-color-selected* #xff7755)
(define *bar-height* 16)
(define *tile-ratio* 1/2)

(define (update-visibility display screen)
  (let loop ((clients (screen-clients screen)))
    (when (pair? clients)
      (let ((c (car clients)))
        (cond
          ((client-visible? c)
           (x-move-window display (client-window c) (client-x c) (client-y c))
           (when (client-floating? c)
             (resize-client
               c (client-x c) (client-y c) (client-w c) (client-h c)))
           (loop (cdr clients)))
          (else
            (loop (cdr clients))
            (x-move-window display
                           (client-window c)
                           (+ (client-x c) (* 2 (screen-w screen)))
                           (client-y c))))))))

(define (focus display client)
  (let* ((s (if client (client-screen client) (current-screen)))
         (c (if (not (and client (client-visible? client)))
               (find-if client-visible? (screen-focus-stack s))
               client)))
    (when (and *selected* (not (eq? *selected* c)))
      (x-set-window-border display
                           (client-window *selected*)
                           (get-colour display s *frame-color-normal*)))
    (cond (c (to-focus-stack-top c)
             (x-set-window-border
               display
               (client-window c)
               (get-colour display s *frame-color-selected*))
             (x-set-input-focus display
                                (client-window c)
                                +revert-to-pointer-root+
                                +current-time+))
          (else (x-set-input-focus display
                                   (screen-root s)
                                   +revert-to-pointer-root+
                                   +current-time+)))
    (set! *selected* c)))

(add-hook *focus-hook* focus)

(define (restack display screen)
  (when *selected*
    (when (client-floating? *selected*)
      (x-raise-window display (client-window *selected*)))
    (x-sync display #f)
    (let loop ()
      (when (x-check-mask-event display +enter-window-mask+)
        (loop)))))

(define (managed-area screen)
  (values (screen-x screen)
          (+ (screen-y screen) *bar-height*)
          (screen-w screen)
          (- (screen-h screen) *bar-height*)))

(define (tile-client-rect display clients x y w h)
  (when (pair? clients)
    (let ((h (floor (/ h (length clients)))))
      (for-each
        (lambda (c)
          (resize-client display c x y (no-border w c) (no-border h c))
          (set! y (+ y (client-h c) (* 2 (client-border c)))))
        clients))))

(define (get-tile-ratio display)
  (if (procedure? *tile-ratio*)
      (*tile-ratio* display)
      *tile-ratio*))

(define (tile display screen)
  (call-with-values
    (lambda () (managed-area screen))
    (lambda (sx sy sw sh)
      (let ((zoom-width (* sw (get-tile-ratio display)))
            (clients (filter client-tiled? (screen-clients screen))))
        (cond ((null? clients))
              ((null? (cdr clients))
               (resize-client display
                              (car clients)
                              sx
                              sy
                              (no-border sw (car clients))
                              (no-border sh (car clients))))
              (else
                (resize-client display
                               (car clients)
                               sx
                               sy
                               (no-border zoom-width (car clients))
                               (no-border sh (car clients)))
                (tile-client-rect display
                                  (cdr clients)
                                  zoom-width
                                  sy
                                  (- sw zoom-width)
                                  sh)))))))

(define (arrange display screen)
  (update-visibility display screen)
  (run-hook *focus-hook* display #f)
  (tile display screen)
  (restack display screen))

(add-hook *arrange-hook* 'arrange)
