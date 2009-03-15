(define-structure client
  name window screen tags display
  x y w h
  border old-border
  fixed? urgent? fullscreen? floating?
  basew baseh incw inch maxw maxh minw minh mina maxa)

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

(define (tag-client c tags)
  ;; there are not many tags so using dumb algorithm
  (let ((old-tags (client-tags c)))
    (for-each
      (lambda (t)
        (set! old-tags (remove t old-tags)))
      tags))
  (client-tags-set! c (append old-tags tags)))

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

(define (update-size-hints! display c)
  (let* ((hints (x-get-wm-normal-hints display (client-window c)))
         (set? (lambda (flag) (bitwise-and (x-size-hints-flags hints) flag))))
    (cond ((set? +p-base-size+)
           (client-basew-set! c (x-size-hints-base-width hints))
           (client-baseh-set! c (x-size-hints-base-height hints)))
          ((set? +p-min-size+)
           (client-basew-set! c (x-size-hints-min-width hints))
           (client-baseh-set! c (x-size-hints-min-height hints)))
          (else
            (client-basew-set! c 0)
            (client-baseh-set! c 0)))
    (cond ((set? +p-resize-inc+)
           (client-incw-set! c (x-size-hints-width-inc hints))
           (client-inch-set! c (x-size-hints-height-inc hints)))
          (else (client-incw-set! c 0)
                (client-inch-set! c 0)))
    (cond ((set? +p-max-size+)
           (client-maxw-set! c (x-size-hints-max-width hints))
           (client-maxh-set! c (x-size-hints-max-height hints)))
          (else (client-maxw-set! c 0)
                (client-maxh-set! c 0)))
    (cond ((set? +p-min-size+)
           (client-minw-set! c (x-size-hints-min-width hints))
           (client-minh-set! c (x-size-hints-min-height hints)))
          ((set? +p-base-size+)
           (client-minw-set! c (x-size-hints-base-width hints))
           (client-minh-set! c (x-size-hints-base-height hints)))
          (else (client-minw-set! c 0)
                (client-minh-set! c 0)))
    (cond ((set? +p-aspect+)
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
                (client-maxa-set! c 0)))
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
  (let ((strings (or
                   (x-get-text-property-list (client-display c)
                                             (client-window c)
                                             (get-atom "_NET_WM_NAME"))
                   (x-get-text-property-list (client-display c)
                                             (client-window c)
                                             +xa-wm-name+))))
    (display-log ";; strings = " strings)))

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
      (when (< i 32)
        (loop (+ i 1))))))

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
    (client-unmapped-set! c 0)
    c))

(define (manage-client display c)
  (let ((s (client-screen c))
        (w (client-window c)))
    (cond ((client-wants-fullscreen? c)
           (fullscreen-client! c))
          (else
            (client-border-set! c *border-width*)
            (hold-client-on-screen c)))
    (x-configure-window display w border-width: (client-border c))
    (x-set-window-border display w (get-colour display s *border-color*))
    (configure-client-window display c)
    (update-size-hints! display c)
    (x-select-input display w *client-input-mask*)
    (x-ungrab-button display +any-button+ +any-modifier+ w)
    (update-title! c)
    ;(process-transient-for-hint! c)
    (client-tags-set! c (list *current-view*))
    (client-floating?-set! c (or (client-fixed? c) (client-fullscreen? c)))
    (when (client-floating? c)
      (x-raise-window display w))
    (screen-clients-set! s (cons c (screen-clients s)))
    (screen-focus-stack-set! s (cons c (screen-focus-stack s)))
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
    (run-hook *arrange-hook* display (client-screen c))
    (x-sync display #f)))

(define (client-visible? c)
  (member *current-view* (client-tags c)))

(define (client-tiled? c)
  (and (client-visible? c) (not (client-floating? c))))

(define (hintize-dimension dim dmin base dmax inc base-is-min? aspect)
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
          (hintize-dimension
            cw minw basew maxw incw base-is-min?
            (and (if (positive? maxa) (< maxa (/ cw ch)) 0) maxa))
          (hintize-dimension
            ch minh baseh maxh inch base-is-min?
            (and (if (positive? mina) (< mina (/ ch cw)) 0) mina)))))))

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
                (w (floor (max w 1)))
                (h (floor (max h 1))))
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

(set! *unmanage-hook* '(unmanage-client))

