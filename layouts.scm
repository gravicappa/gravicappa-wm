(define (tile-client-rect clients x y w h)
  (let loop ((clients clients)
             (n (length clients))
             (h h)
             (y y))
    (if (pair? clients)
        (let ((c (car clients))
              (ch (floor (/ h n))))
          (resize-client! c x y (no-border w c) (no-border ch c))
          (loop (cdr clients)
                (- n 1)
                (- h (client-h c) (* 2 (client-border c)))
                (+ y (client-h c) (* 2 (client-border c))))))))

(define (tiler ratio)
  (lambda (screen)
    (call-with-managed-area
      screen
      (lambda (sx sy sw sh)
        (let ((zoom-width (* sw ratio))
              (clients (filter client-tiled? (screen-clients screen))))
          (cond ((null? clients))
                ((null? (cdr clients))
                 (resize-client! (car clients)
                                 sx
                                 sy
                                 (no-border sw (car clients))
                                 (no-border sh (car clients))))
                (else
                  (resize-client! (car clients)
                                  sx
                                  sy
                                  (no-border zoom-width (car clients))
                                  (no-border sh (car clients)))
                  (tile-client-rect (cdr clients)
                                    zoom-width
                                    sy
                                    (- sw zoom-width)
                                    sh))))))))

(define (fullscreen screen)
  (call-with-managed-area
    screen
    (lambda (sx sy sw sh)
      (for-each (lambda (c)
                  (if (eq? c (current-client))
                      (resize-client! c
                                      sx
                                      sy
                                      (no-border sw c)
                                      (no-border sh c))
                      (hide-client! c)))
                (filter client-tiled? (screen-clients screen))))))
