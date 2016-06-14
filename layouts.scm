(define tile-ratio 56/100)

(define (tile screen)
  (define (tile-rect mwins x y w h)
    (let loop ((mwins mwins)
               (n (length mwins))
               (h h)
               (y y))
      (if (pair? mwins)
          (let* ((m (car mwins))
                 (ch (no-border (floor (/ h n)) m)))
            (resize-w/hints m x y (no-border w m) ch)
            (let ((dy (min (+ (mwin-h m) (* 2 (mwin-border m)) (* 2 gap)))))
              (loop (cdr mwins) (- n 1) (- h dy) (+ y dy)))))))
  
  (call-with-managed-area
   screen
   (lambda (sx sy sw sh)
     (let ((zoom-width (floor (* sw tile-ratio)))
           (mwins (filter mwin-tiled? (screen-mwins-list screen))))
       (cond ((null? mwins))
             ((null? (cdr mwins))
              (resize-w/hints (car mwins)
                              sx
                              sy
                              (no-border sw (car mwins))
                              (no-border sh (car mwins))))
             (else
              (resize-w/hints (car mwins)
                              sx
                              sy
                              (- (no-border zoom-width (car mwins)) (* 2 gap))
                              (no-border sh (car mwins)))
              (tile-rect (cdr mwins) zoom-width sy (- sw zoom-width) sh))))))
  (restack (current-display) screen (screen-stack-list screen)))

(define (fullscreen screen)
  (call-with-managed-area
   screen
   (lambda (sx sy sw sh)
     (for-each
      (lambda (m)
        (resize-w/hints m sx sy (no-border sw m) (no-border sh m)))
      (filter mwin-tiled? (screen-stack-list screen)))))
  (restack (current-display) screen (screen-stack-list screen)))
