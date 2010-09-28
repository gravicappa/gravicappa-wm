(define (client-tagged? c tag)
  (and (client? c) (member tag (client-tags c))))

(define (client-visible? c)
  (client-tagged? c (current-view)))

(define (client-tiled? c)
  (and (client-visible? c) (not (client-floating? c))))

(define (update-visibility disp screen)
  (let loop ((clients (cdr (screen-clients screen))))
    (if (pair? clients)
        (let ((c (car clients)))
          (cond
            ((client-visible? c)
             (x-move-window disp (client-window c) (client-x c) (client-y c))
             (if (client-floating? c)
                 (resize-client! c
                                 (client-x c)
                                 (client-y c)
                                 (client-w c)
                                 (client-h c)))
             (loop (cdr clients)))
            (else
              (loop (cdr clients))
              (x-move-window disp
                             (client-window c)
                             (+ (client-x c) (* 2 (screen-w screen)))
                             (client-y c))))))))

(define (focus-client disp client)
  (let* ((s (current-screen))
         (c (if (not (and client (client-visible? client)))
                (find-if client-visible? (screen-focus-stack s))
                client)))
    (if (and (current-client) (not (eq? (current-client) c)))
        (begin
          (x-ungrab-button disp
                           x#+any-button+
                           x#+any-modifier+
                           (client-window (current-client)))
          (x-set-window-border disp
                               (client-window (current-client))
                               (get-colour disp s (border-colour)))))
    (cond (c (move-client-to-top! c (screen-focus-stack s))
             (grab-buttons! c)
             (x-set-window-border
               disp
               (client-window c)
               (get-colour disp s (selected-border-colour)))
             (x-set-input-focus disp
                                (client-window c)
                                x#+revert-to-pointer-root+
                                x#+current-time+)
             (if (client-floating? c)
                 (x-raise-window disp (client-window c))))
          (else (x-set-input-focus disp
                                   (screen-root s)
                                   x#+revert-to-pointer-root+
                                   x#+current-time+)))
    (current-client c)))

(define (restack disp screen)
  (if (current-client)
      (begin
        (if (client-floating? (current-client))
            (x-raise-window disp (client-window (current-client))))
        (let loop ((clients (filter client-tiled? (screen-clients screen)))
                   (sibling x#+none+))
          (if (pair? clients)
              (begin
                (x-configure-window disp
                                    (client-window (car clients))
                                    sibling: sibling
                                    stack-mode: x#+below+)
                (loop (cdr clients) (client-window (car clients))))))
        (x-sync disp #f)
        (let loop ()
          (if (x-check-mask-event disp x#+enter-window-mask+)
              (loop))))))

(define (call-with-managed-area screen ret)
  (ret (screen-x screen)
       (+ (screen-y screen) (bar-height))
       (screen-w screen)
       (- (screen-h screen) (bar-height))))

(define (no-border dim client)
  (- dim (* 2 (client-border client))))

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

;(define (tile-client-rect clients x y w h)
;  (if (pair? clients)
;      (let ((ch (floor (/ h (length clients)))))
;        (for-each
;          (lambda (c)
;            (resize-client! c x y (no-border w c) (no-border ch c))
;            (set! y (+ y (client-h c) (* 2 (client-border c))))
;            (if (> (client-h c) ch)
;                (display-log 10 "Client is higher than said to be ("
;                                (client-h c) " > " ch ")")))
;          clients))))

(define (tile disp screen)
  (call-with-managed-area
    screen
    (lambda (sx sy sw sh)
      (let ((zoom-width (* sw (tile-ratio)))
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
                                  sh)))))))

(define arrange-clients tile)

(define (arrange-screen dpy screen)
  (update-visibility dpy screen)
  (focus-client dpy #f)
  (arrange-clients dpy screen)
  (restack dpy screen)
  (x-sync dpy #f))
