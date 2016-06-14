(define (mwin-tagged? m tag)
  (and (mwin? m) (member tag (mwin-tags m))))

(define (mwin-visible? m)
  (mwin-tagged? m current-tag))

(define (mwin-tiled? m)
  (and (mwin-visible? m) (not (mwin-floating? m))))

(define (hide-mwin m)
  (x-move-window (current-display)
                 (mwin-window m)
                 (+ (mwin-x m) (* 2 (screen-w (current-screen))))
                 (mwin-y m)))

(define (update-visibility dpy screen)
  (let loop ((mwins (screen-mwins-list screen)))
    (if (pair? mwins)
        (let ((m (car mwins)))
          (cond
           ((mwin-visible? m)
            (x-move-window dpy (mwin-window m) (mwin-x m) (mwin-y m))
            (if (mwin-floating? m)
                (resize-w/hints
                 m (mwin-x m) (mwin-y m) (mwin-w m) (mwin-h m)))
            (loop (cdr mwins)))
           (else
            (loop (cdr mwins))
            (hide-mwin m)))))))

(define (focus-mwin dpy mwin)
  (let* ((s (current-screen))
         (m (if (not (and mwin (mwin-visible? mwin)))
                (find-if mwin-visible? (screen-stack-list s))
                mwin)))
    (cond ((and current-mwin (not (eq? current-mwin m)))
           (x-ungrab-button dpy
                            x#+any-button+
                            x#+any-modifier+
                            (mwin-window current-mwin))
           (x-set-window-border dpy
                                (mwin-window current-mwin)
                                (get-colour dpy s border-colour))))
    (cond ((mwin? m)
           (move-to-stack-top! m s)
           (grab-buttons m)
           (x-set-window-border dpy
                                (mwin-window m)
                                (get-colour dpy s selected-border-colour))
           (x-set-input-focus dpy
                              (mwin-window m)
                              x#+revert-to-pointer-root+
                              x#+current-time+))
          (else (x-set-input-focus dpy
                                   (screen-root s)
                                   x#+revert-to-pointer-root+
                                   x#+current-time+)))
    (set! current-mwin m)
    (focus-hook)))

(define (restack dpy screen mwins)
  (cond (current-mwin
         (if (mwin-floating? current-mwin)
             (x-raise-window dpy (mwin-window current-mwin)))
         (let loop ((mwins (filter mwin-tiled? mwins))
                    (sibling x#+none+))
           (if (pair? mwins)
               (let ((m (car mwins)))
                 (if (not (mwin-floating? m))
                     (x-configure-window dpy
                                         (mwin-window m)
                                         sibling: sibling
                                         stack-mode: x#+below+))
                 (loop (cdr mwins) (mwin-window m)))))
         (x-sync dpy #f)
         (do () ((not (x-check-mask-event dpy x#+enter-window-mask+)))))))

(define (call-with-managed-area screen ret)
  (ret (+ (screen-x screen) (vector-ref borders 0))
       (+ (screen-y screen) (vector-ref borders 1))
       (- (screen-w screen) (vector-ref borders 0) (vector-ref borders 2))
       (- (screen-h screen) (vector-ref borders 1) (vector-ref borders 3))))

(define (no-border a mwin)
  (- a (* 2 (mwin-border mwin))))

(define current-layout tile)

(define (arrange-screen dpy screen)
  (update-visibility dpy screen)
  (focus-mwin dpy #f)
  (current-layout screen)
  (x-sync dpy #f))

(define (update-layout)
  (arrange-screen (current-display) (current-screen)))
