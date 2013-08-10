(define (client-tagged? c tag)
  (and (client? c) (member tag (client-tags c))))

(define (client-visible? c)
  (client-tagged? c (current-tag)))

(define (client-tiled? c)
  (and (client-visible? c) (not (client-floating? c))))

(define (hide-client! c)
  (x-move-window (current-display)
                 (client-window c)
                 (+ (client-x c) (* 2 (screen-w (current-screen))))
                 (client-y c)))

(define (update-visibility dpy screen)
  (let loop ((clients (clients-list screen)))
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
                (find-if client-visible? (clients-stack s))
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
    (cond ((client? c)
           (move-client-to-top! c clients-stack s)
           (grab-buttons! c)
           (x-set-window-border dpy
                                (client-window c)
                                (get-colour dpy s (selected-border-colour)))
           (x-set-input-focus dpy
                              (client-window c)
                              x#+revert-to-pointer-root+
                              x#+current-time+))
          (else (x-set-input-focus dpy
                                   (screen-root s)
                                   x#+revert-to-pointer-root+
                                   x#+current-time+)))
    (set! current-client (lambda () c))
    (focus-hook)))

(define (restack dpy screen clients)
  (if (current-client)
      (begin
        (if (client-floating? (current-client))
            (x-raise-window dpy (client-window (current-client))))
        (let loop ((clients (filter client-tiled? clients))
                   (sibling x#+none+))
          (if (pair? clients)
              (let ((c (car clients)))
                (if (not (client-floating? c))
                    (x-configure-window dpy
                                        (client-window c)
                                        sibling: sibling
                                        stack-mode: x#+below+))
                (loop (cdr clients) (client-window c)))))
        (x-sync dpy #f)
        (do () ((not (x-check-mask-event dpy x#+enter-window-mask+)))))))

(define (call-with-managed-area screen ret)
  (ret (screen-x screen)
       (+ (screen-y screen) (bar-height))
       (screen-w screen)
       (- (screen-h screen) (bar-height))))

(define (no-border a client)
  (- a (* 2 (client-border client))))

(define current-layout (tiler 56/100))

(define (arrange-screen dpy screen)
  (update-visibility dpy screen)
  (focus-client dpy #f)
  (current-layout screen)
  (x-sync dpy #f))

(define (update-layout)
  (arrange-screen (current-display) (current-screen)))
