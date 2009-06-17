(define-structure client
  name window screen tags display class
  x y w h
  border old-border
  fixed? urgent? fullscreen? floating?
  basew baseh incw inch maxw maxh minw minh mina maxa)

(define (make-client* display window wa screen)
  (let ((c (make-client #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
                        #f #f #f #f #f #f #f #f)))
    (client-display-set! c display)
    (client-screen-set! c screen)
    (client-window-set! c window)
    (client-x-set! c (x-window-attributes-x wa))
    (client-y-set! c (x-window-attributes-y wa))
    (client-w-set! c (x-window-attributes-width wa))
    (client-h-set! c (x-window-attributes-height wa))
    (client-old-border-set! c (x-window-attributes-border-width wa))
    c))

(define *client-input-mask* (bitwise-ior +enter-window-mask+
                                         +focus-change-mask+
                                         +property-change-mask+
                                         +structure-notify-mask+))

(define (remove-from-stack c)
  (let ((s (client-screen c)))
    (screen-clients-set! s (remove c (screen-clients s)))))

(define (remove-from-focus-stack c)
  (let ((s (client-screen c)))
    (screen-focus-stack-set! s (remove c (screen-focus-stack s)))))

(define (to-stack-top c)
  (let ((s (client-screen c)))
    (screen-clients-set! s (cons c (remove c (screen-clients s))))))

(define (to-focus-stack-top c)
  (let ((s (client-screen c)))
    (screen-focus-stack-set! s (cons c (remove c (screen-focus-stack s))))))

(define (client-wants-fullscreen? client)
  (and (eq? (client-w client) (screen-w (client-screen client)))
       (eq? (client-h client) (screen-h (client-screen client)))))

(define (fullscreen-client! client)
  (client-border-set! client 0)
  (client-fullscreen?-set! client #t)
  (client-x-set! client (screen-x (client-screen client)))
  (client-y-set! client (screen-y (client-screen client))))

(define (hold-client-on-screen c)
  (let ((hold (lambda (x w ax aw b)
                (max ax
                     (if (> (+ x w (* 2 b)) (+ ax aw))
                         (- (+ ax aw) w)
                         x))))
        (border (client-border c))
        (s (client-screen c)))
    (client-x-set!
      c (hold (client-x c) (client-w c) (screen-x s) (screen-w s) border))
    (client-y-set!
      c (hold (client-y c) (client-h c) (screen-y s) (screen-h s) border))))

(define (center-client-on-screen c)
  (let ((f (lambda (a1 a2 b1 b2)
             (if (> (+ (- a1 b1) a2) b2)
                 (floor (+ b1 (/ (- b2 a2) 2)))
                 a1)))
        (s (client-screen c)))
    (client-x-set! c (f (client-x c) (client-w c) (screen-x s) (screen-w s)))
    (client-y-set! c (f (client-y c) (client-h c) (screen-y s) (screen-h s)))))

(define (configure-client-window display c)
  (let ((ev (make-x-event-box))
        (win (client-window c)))
    (x-configure-event-type-set! ev +configure-notify+)
    (x-configure-event-display-set! ev display)
    (x-configure-event-window-set! ev win)
    (x-configure-event-event-set! ev win)
    (x-configure-event-x-set! ev (client-x c))
    (x-configure-event-y-set! ev (client-y c))
    (x-configure-event-width-set! ev (client-w c))
    (x-configure-event-height-set! ev (client-h c))
    (x-configure-event-border-width-set! ev (client-border c))
    (x-configure-event-above-set! ev +none+)
    (x-configure-event-override-redirect?-set! ev #f)
    (x-send-event display win #f +structure-notify-mask+ ev)))

(define (hint-set? flag hints)
  (bitwise-and (x-size-hints-flags hints) flag))

(define (set-client-base-size! c hints)
  (cond ((hint-set? +p-base-size+ hints)
         (client-basew-set! c (x-size-hints-base-width hints))
         (client-baseh-set! c (x-size-hints-base-height hints)))
        ((hint-set? +p-min-size+ hints)
         (client-basew-set! c (x-size-hints-min-width hints))
         (client-baseh-set! c (x-size-hints-min-height hints)))
        (else (client-basew-set! c 0)
              (client-baseh-set! c 0))))

(define (set-client-inc! c hints)
  (cond ((hint-set? +p-resize-inc+ hints)
         (client-incw-set! c (x-size-hints-width-inc hints))
         (client-inch-set! c (x-size-hints-height-inc hints)))
        (else (client-incw-set! c 0)
              (client-inch-set! c 0))))

(define (set-client-max-size! c hints)
  (cond ((hint-set? +p-max-size+ hints)
         (client-maxw-set! c (x-size-hints-max-width hints))
         (client-maxh-set! c (x-size-hints-max-height hints)))
        (else (client-maxw-set! c 0)
              (client-maxh-set! c 0))))

(define (set-client-min-size! c hints)
  (cond ((hint-set? +p-min-size+ hints)
         (client-minw-set! c (x-size-hints-min-width hints))
         (client-minh-set! c (x-size-hints-min-height hints)))
        ((hint-set? +p-base-size+ hints)
         (client-minw-set! c (x-size-hints-base-width hints))
         (client-minh-set! c (x-size-hints-base-height hints)))
        (else (client-minw-set! c 0)
              (client-minh-set! c 0))))

(define (set-client-aspect! c hints)
  (cond ((hint-set? +p-aspect+)
         (client-mina-set! c
                           (if (positive? (x-size-hints-min-aspect-y hints))
                               (/ (x-size-hints-min-aspect-x hints)
                                  (x-size-hints-min-aspect-y hints))
                             0))
         (client-maxa-set! c
                           (if (positive? (x-size-hints-max-aspect-y hints))
                               (/ (x-size-hints-max-aspect-x hints)
                                  (x-size-hints-max-aspect-y hints))
                             0)))
        (else (client-mina-set! c 0)
              (client-maxa-set! c 0))))

(define (update-size-hints! display c)
  (let ((hints (x-get-wm-normal-hints display (client-window c))))
    (set-client-base-size! c hints)
    (set-client-inc! c hints)
    (set-client-max-size! c hints)
    (set-client-min-size! c hints)
    (set-client-aspect! c hints)
    (client-fixed?-set! c
                        (and (positive? (client-maxw c))
                             (positive? (client-maxh c))
                             (positive? (client-minw c))
                             (positive? (client-minh c))
                             (eq? (client-maxw c) (client-minw c))
                             (eq? (client-maxh c) (client-minh c))))))

(define (update-wm-hints! display c)
  ;; TODO: process urgency hint
  #f
  )

(define (update-title! c)
  (let ((strings (or (x-get-text-property-list (client-display c)
                                               (client-window c)
                                               (get-atom "_NET_WM_NAME"))
                     (x-get-text-property-list (client-display c)
                                               (client-window c)
                                               +xa-wm-name+))))
    (if (pair? strings)
        (client-name-set! c (car strings)))))

(define (grab-buttons c)
  (let ((display (client-display c))
        (mask (bitwise-ior +button-press-mask+ +button-release-mask+))
        (win (client-window c)))
    (x-ungrab-button display +any-button+ +any-modifier+ (client-window c))
    (let loop ((i 1))
      (x-grab-button display
                     i
                     +any-modifier+
                     win
                     #f
                     mask
                     +grab-mode-sync+
                     +grab-mode-async+
                     +none+
                     +none+)
      (if (< i 32)
          (loop (+ i 1))))))

(define (process-transient-for-hint! c)
  (let* ((display (client-display c))
         (w (client-window c))
         (transient (x-get-transient-for-hint display w)))
    (if (not (eq? transient  +none+))
        (begin
          (client-floating?-set! c #t)
          (let ((parent (client-from-window* transient)))
            (if parent
                (client-tags-set! c (client-tags parent))))))))

(define (manage-client display c)
  (let ((s (client-screen c))
        (w (client-window c)))
    (cond ((client-wants-fullscreen? c)
           (fullscreen-client! c))
          (else (client-border-set! c *border-width*)
                (hold-client-on-screen c)))
    (x-configure-window display w border-width: (client-border c))
    (x-set-window-border display w (get-colour display s *border-color*))
    (configure-client-window display c)
    (update-size-hints! display c)
    (x-select-input display w *client-input-mask*)
    (x-ungrab-button display +any-button+ +any-modifier+ w)
    (update-title! c)
    (process-transient-for-hint! c)
    (client-class-set! c (x-get-class-hint display w))
    (display-log "client class: " (client-class c) " name: " (client-name c))
    (run-hook *rules-hook* c)
    (if (null? (client-tags c))
        (client-tags-set! c (list *current-view*)))
    (run-hook *retag-hook*)
    (client-floating?-set! c (or (client-floating? c)
                                 (client-fixed? c)
                                 (client-fullscreen? c)))
    (if (client-floating? c)
        (x-raise-window display w))
    (screen-clients-set! s (cons c (screen-clients s)))
    (if (not (member c (screen-focus-stack s)))
        (screen-focus-stack-set! s (cons c (screen-focus-stack s))))
    (x-move-resize-window display
                          w
                          (+ (client-x c) (* 2 (screen-w s)))
                          (client-y c)
                          (client-w c)
                          (client-h c))
    (x-map-window display w)
    (x-window-state-set! display w (get-atom "WM_STATE") +normal-state+)
    (run-hook *arrange-hook* display s)))

(define (unmanage-client display c)
  (let ((w (client-window c)))
    (dynamic-wind
      (lambda ()
        (x-grab-server display)
        (set-x-error-handler! (lambda (display ev) #t)))
      (lambda ()
        (x-configure-window display w border-width: (client-old-border c))
        (remove-from-stack c)
        (remove-from-focus-stack c)
        (x-ungrab-button display +any-button+ +any-modifier+ w)
        (x-window-state-set! display
                             w
                             (get-atom "WM_STATE")
                             +withdrawn-state+))
      (lambda ()
        (x-sync display #f)
        (set-x-error-handler! uwm-error-handler)
        (x-ungrab-server display)))
    (run-hook *retag-hook*)
    (run-hook *arrange-hook* display (client-screen c))
    (x-sync display #f)))

(define (client-tagged? c tag)
  (member tag (client-tags c)))

(define (client-visible? c)
  (client-tagged? c *current-view*))

(define (client-tiled? c)
  (and (client-visible? c) (not (client-floating? c))))

(define (hintize-dimension dim dmin base dmax inc base-is-min?)
  (let ((identity (lambda (x) x))
        (minimize (lambda (dim) (max dim 1)))
        (cut-base (lambda (dim when?) (if when? (- dim base) dim)))
        (adjust-inc (lambda (dim)
                      (if (positive? inc) (- dim (modulo dim inc)) dim)))
        (restore-base (lambda (dim) (+ dim base)))
        (clamp (lambda (dim) (if (positive? dmax) (min dim dmax) dim))))
    (floor (clamp (max (restore-base (identity (cut-base dim base-is-min?)))
                       dmin)))))

(define (adjust-aspect w h mina maxa)
  (if (and (positive? mina) (positive? maxa))
      (cond ((> (/ w h) maxa) (values (* h maxa) h))
            ((< (/ w h) mina) (values w (/ w mina)))
            (else (values w h)))
      (values w h)))

(define (respect-client-hints client w h)
  (let* ((border (client-border client))
         (minw (client-minw client))
         (basew (client-basew client))
         (maxw (client-maxw client))
         (minh (client-minh client))
         (baseh (client-baseh client))
         (maxh (client-maxh client))
         (incw (client-incw client))
         (inch (client-inch client))
         (mina (client-mina client))
         (maxa (client-maxa client))
         (base-is-min? (and (eq? basew minw) (eq? baseh minh)))
         (prepare (lambda (dim base)
                    (let ((dim (max dim 1)))
                      (if base-is-min? dim (- dim base))))))
    (call-with-values
      (lambda ()
        (adjust-aspect (prepare w basew) (prepare h baseh) mina maxa))
      (lambda (cw ch)
        (values
          (hintize-dimension cw minw basew maxw incw base-is-min?)
          (hintize-dimension ch minh baseh maxh inch base-is-min?))))))

(define (clamp-dimension dim size head width)
  (let ((dim (if (> dim (+ head width))
                 (- (+ head width) size)
                 dim)))
    (if (< (+ dim size) head)
        head
        dim)))

(define (resize-client c x y w h)
  (let* ((s (client-screen c))
         (sx (screen-x s))
         (sy (screen-y s))
         (sw (screen-w s))
         (sh (screen-h s))
         (border (client-border c)))
    (call-with-values
      (lambda () (respect-client-hints c w h))
      (lambda (w h)
        (when (and (positive? w) (positive? h))
          (let ((x (floor (clamp-dimension x (+ w (* 2 border)) sx sw)))
                (y (floor (clamp-dimension y (+ h (* 2 border)) sy sh)))
                (w (floor (max w *bar-height*)))
                (h (floor (max h *bar-height*))))
            (unless (and (= (client-x c) x) (= (client-y c) y)
                         (= (client-w c) w) (= (client-h c) h))
              (client-x-set! c x)
              (client-y-set! c y)
              (client-w-set! c w)
              (client-h-set! c h)
              (x-configure-window (client-display c)
                                  (client-window c)
                                  x: x
                                  y: y
                                  width: w
                                  height: h
                                  border-width: (client-border c))
              (configure-client-window (client-display c) c)
              (x-sync (client-display c) #f))))))))

(define (client-has-delete-proto? c)
  (when c
    (member (get-atom "WM_DELETE_WINDOW")
            (x-get-wm-protocols (client-display c) (client-window c)))))

(define (send-client-kill-message c)
  (let ((ev (make-x-event-box))
        (win (client-window c))
        (display (client-display c)))
    (x-client-message-event-type-set! ev +client-message+)
    (x-client-message-event-window-set! ev win)
    (x-client-message-event-message-type-set! ev (get-atom "WM_PROTOCOLS"))
    (x-client-message-event-format-set! ev 32)
    (x-client-message-event-data-l-set! ev 0 (get-atom "WM_DELETE_WINDOW"))
    (x-client-message-event-data-l-set! ev 1 +current-time+)
    (x-send-event display win #f +no-event-mask+ ev)))

(define (kill-client c)
  (when c
    (if (client-has-delete-proto? c)
        (send-client-kill-message c)
        (x-kill-client (client-display c) (client-window c)))))

(set! *unmanage-hook* '(unmanage-client))

