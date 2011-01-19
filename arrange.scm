(define (client-tagged? c tag)
  (and (client? c) (member tag (client-tags c))))

(define (client-visible? c)
  (client-tagged? c (current-view)))

(define (client-tiled? c)
  (and (client-visible? c) (not (client-floating? c))))

(define (hide-client! c)
  (x-move-window (current-display)
                 (client-window c)
                 (+ (client-x c) (* 2 (screen-w (current-screen))))
                 (client-y c)))

(define (update-visibility dpy screen)
  (let loop ((clients (cdr (screen-clients screen))))
    (if (pair? clients)
        (let ((c (car clients)))
          (cond
            ((client-visible? c)
             (x-move-window dpy (client-window c) (client-x c) (client-y c))
             (if (client-floating? c)
                 (resize-client! c
                                 (client-x c)
                                 (client-y c)
                                 (client-w c)
                                 (client-h c)))
             (loop (cdr clients)))
            (else
              (loop (cdr clients))
              (hide-client! c)))))))

(define (focus-client dpy client)
  (let* ((s (current-screen))
         (c (if (not (and client (client-visible? client)))
                (find-if client-visible? (screen-stack s))
                client)))
    (if (and (current-client) (not (eq? (current-client) c)))
        (begin
          (x-ungrab-button dpy
                           x#+any-button+
                           x#+any-modifier+
                           (client-window (current-client)))
          (x-set-window-border dpy
                               (client-window (current-client))
                               (get-colour dpy s (border-colour)))))
    (cond (c (move-client-to-top! c (screen-stack s))
             (grab-buttons! c)
             (x-set-window-border dpy
                                  (client-window c)
                                  (get-colour dpy s (selected-border-colour)))
             (x-set-input-focus dpy
                                (client-window c)
                                x#+revert-to-pointer-root+
                                x#+current-time+)
             (if (client-floating? c)
                 (x-raise-window dpy (client-window c))))
          (else (x-set-input-focus dpy
                                   (screen-root s)
                                   x#+revert-to-pointer-root+
                                   x#+current-time+)))
    (set! current-client (lambda () c))))

(define (restack dpy screen)
  (if (current-client)
      (begin
        (if (client-floating? (current-client))
            (x-raise-window dpy (client-window (current-client))))
        (let loop ((clients (filter client-tiled? (screen-stack screen)))
                   (sibling x#+none+))
          (if (pair? clients)
              (begin
                (x-configure-window dpy
                                    (client-window (car clients))
                                    sibling: sibling
                                    stack-mode: x#+below+)
                (loop (cdr clients) (client-window (car clients))))))
        (x-sync dpy #f)
        (let loop ()
          (if (x-check-mask-event dpy x#+enter-window-mask+)
              (loop))))))

(define (call-with-managed-area screen ret)
  (ret (screen-x screen)
       (+ (screen-y screen) (bar-height))
       (screen-w screen)
       (- (screen-h screen) (bar-height))))

(define (no-border a client)
  (- a (* 2 (client-border client))))

(define current-layout (lambda () (tiler 56/100)))

(define (arrange-screen dpy screen)
  (update-visibility dpy screen)
  (focus-client dpy #f)
  ((current-layout) screen)
  (restack dpy screen)
  (x-sync dpy #f))
