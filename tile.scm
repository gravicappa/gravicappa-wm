(define (update-visibility display screen)
  (let loop ((clients (screen-clients screen)))
    (when (pair? clients)
      (let ((c (car clients)))
        (cond
          ((client-visible? c)
           (x-move-window display (client-window c) (client-x c) (client-y c))
           (when (client-floating? c)
             (resize-client c
                            (client-x c)
                            (client-y c)
                            (client-w c)
                            (client-h c)))
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
      (x-ungrab-button display
                       +any-button+
                       +any-modifier+
                       (client-window *selected*))
      (x-set-window-border display
                           (client-window *selected*)
                           (get-colour display s *border-color*)))
    (cond (c (to-focus-stack-top c)
             (grab-buttons c)
             (x-set-window-border
               display
               (client-window c)
               (get-colour display s *selected-border-color*))
             (x-set-input-focus display
                                (client-window c)
                                +revert-to-pointer-root+
                                +current-time+)
             (if (client-floating? c)
                 (x-raise-window display (client-window c))))
          (else (x-set-input-focus display
                                   (screen-root s)
                                   +revert-to-pointer-root+
                                   +current-time+)))
    (set! *selected* c)))

(define (restack display screen)
  (when *selected*
    (when (client-floating? *selected*)
      (x-raise-window display (client-window *selected*)))
    (let loop ((clients (filter client-tiled? (screen-clients screen)))
               (sibling +none+))
      (when (pair? clients)
        (x-configure-window display
                            (client-window (car clients))
                            sibling: sibling
                            stack-mode: +below+)
        (loop (cdr clients) (client-window (car clients)))))
    (x-sync display #f)
    (let loop ()
      (when (x-check-mask-event display +enter-window-mask+)
        (loop)))))

(define (managed-area screen)
  (values (screen-x screen)
          (+ (screen-y screen) *bar-height*)
          (screen-w screen)
          (- (screen-h screen) *bar-height*)))

(define (no-border dim client)
  (- dim (* 2 (client-border client))))

(define (tile-client-rect clients x y w h)
  (let loop ((clients clients)
             (n (length clients))
             (h h)
             (y y))
    (when (pair? clients)
      (let ((c (car clients))
            (ch (floor (/ h n))))
        (resize-client c x y (no-border w c) (no-border ch c))
        (loop (cdr clients)
              (- n 1)
              (- h (client-h c) (* 2 (client-border c)))
              (+ y (client-h c) (* 2 (client-border c))))))))

;(define (tile-client-rect clients x y w h)
;  (when (pair? clients)
;    (let ((ch (floor (/ h (length clients)))))
;      (for-each
;        (lambda (c)
;          (resize-client c x y (no-border w c) (no-border ch c))
;          (set! y (+ y (client-h c) (* 2 (client-border c))))
;          (when (> (client-h c) ch)
;            (display-log "Client is higher than said to be ("
;                         (client-h c) " > " ch ")")))
;        clients))))

(define (tile tile-ratio display screen)
  (call-with-values
    (lambda () (managed-area screen))
    (lambda (sx sy sw sh)
      (let ((zoom-width (* sw tile-ratio))
            (clients (filter client-tiled? (screen-clients screen))))
        (cond ((null? clients))
              ((null? (cdr clients))
               (resize-client (car clients)
                              sx
                              sy
                              (no-border sw (car clients))
                              (no-border sh (car clients))))
              (else
                (resize-client (car clients)
                               sx
                               sy
                               (no-border zoom-width (car clients))
                               (no-border sh (car clients)))
                (tile-client-rect (cdr clients)
                                  zoom-width
                                  sy
                                  (- sw zoom-width)
                                  sh)))))))

(define (arrange display screen)
  (update-visibility display screen)
  (run-hook *focus-hook* display #f)
  (tile *tile-ratio* display screen)
  (restack display screen))

(set! *manage-hook* '(manage-window))
(set! *focus-hook* '(focus))
(set! *arrange-hook* '(arrange))
