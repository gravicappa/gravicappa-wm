(define-structure client
  name window screen tags 
  x y w h 
  border old-border
  fixed? urgent? fullscreen? floating?
  basew baseh incw inch maxw maxh minw minh mina maxa)

(define client-input-mask (bitwise-ior +enter-window-mask+
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

(define (fullscreen-client client)
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

(define (maybe-center-client-on-screen c)
  (let ((center (lambda (a1 a2 b1 b2)
                  (if (> (+ (- a1 b1) a2) b2)
                      (+ b1 (/ (- b2 a2) 2))
                      a1)))
        (s (client-screen c)))
    (when (client-floating? c)
      (client-x-set! 
        c (center (client-x c) (client-w c) (screen-x s) (screen-w s)))
      (client-y-set! 
        c (center (client-y c) (client-h c) (screen-y s) (screen-h s))))))

(define (tag-client client tags)
  #f)

(define (configure-client display c)
  (let ((ev (make-x-event-box))
        (win (client-window c)))
    (x-any-event-display-set! ev display)
    (x-any-event-type-set! ev +configure-notify+)
    (x-any-event-window-set! ev win)
    (x-configure-event-event-set! ev win)
    (x-configure-event-x-set! ev (client-x c))
    (x-configure-event-y-set! ev (client-y c))
    (x-configure-event-width-set! ev (client-w c))
    (x-configure-event-height-set! ev (client-h c))
    (x-configure-event-border-width-set! ev (client-border c))
    (x-configure-event-above-set! ev +none+)
    (x-configure-event-override-redirect?-set! ev #f)
    (x-send-event display win 0 +structure-notify-mask+ ev)))

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

(define (make-client* window wa screen)
  (let ((c (make-client #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f #f
                        #f #f #f #f #f #f)))
    (client-screen-set! c screen)
    (client-window-set! c window)
    (client-x-set! c (x-window-attributes-x wa))
    (client-y-set! c (x-window-attributes-y wa))
    (client-w-set! c (x-window-attributes-width wa))
    (client-h-set! c (x-window-attributes-height wa))
    (client-old-border-set! c (x-window-attributes-border-width wa))
    c))

(define (manage-client display c)
  (let ((s (client-screen c)))
    (cond ((client-wants-fullscreen? c)
           (display-log "[x11] window "
                        (client-window c)
                        " wants fullscreen")
           (fullscreen-client c))
          (else
            (client-border-set! c border-width)
            (hold-client-on-screen c)))
    (x-configure-window 
      display (client-window c) border-width: (client-border c))
    (x-set-window-border 
      display (client-window c) (get-colour display s *frame-color-normal*))
    (configure-client display c)
    (update-size-hints! display c)
    (x-select-input display (client-window c) client-input-mask)
    ;(grabbuttons c #f)
    ;(update-title! c)
    ;(process-transient-for-hint! c)
    (client-floating?-set! c (or (client-fixed? c) (client-fullscreen? c)))
    ;(tag-client (list current-view) c)
    (when (client-floating? c)
      (x-raise-window display (client-window c)))
    (screen-clients-set! s (cons c (screen-clients s)))
    (screen-focus-stack-set! s (cons c (screen-focus-stack s)))
    (x-move-resize-window display
                          (client-window c)
                          (+ (client-x c) (* 2 (screen-w s)))
                          (client-y c)
                          (client-w c)
                          (client-h c))
    (x-map-window display (client-window c))
    (x-window-state-set! display (client-window c) +wm-state+ +normal-state+)
    (run-hook *arrange-hook* display s)
    (x-sync display #f)))

(define (unmanage-client display c)
  (dynamic-wind
    (lambda ()
      (x-grab-server display)
      (set-x-error-handler! (lambda (display ev) #t)))
    (lambda ()
      (x-configure-window display
                          (client-window c)
                          border-width: (client-old-border c))
      (remove-from-stack c)
      (remove-from-focus-stack c)
      (x-ungrab-button display +any-button+ +any-modifier+ (client-window c))
      (x-window-state-set! display
                           (client-window c)
                           +wm-state+
                           +withdrawn-state+))
    (lambda ()
      (x-sync display #f)
      (set-x-error-handler! uwm-error-handler)
      (x-ungrab-server display)))
  (run-hook *arrange-hook* display (client-screen c))
  (x-sync display #f))

(add-hook *unmanage-hook* 'unmanage-client)

(define (client-visible? c)
  #t)

(define (client-tiled? c)
  (and (client-visible? c) (not (client-floating? c))))

(define (no-border dim client)
  (- dim (* 2 (client-border client))))

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
            (t (values w h)))
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

(define (resize-client display c x y w h)
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
          (let ((x (clamp-dimension x (+ w (* 2 border)) sx sw))
                (y (clamp-dimension y (+ h (* 2 border)) sy sh))
                (w (max w *bar-height*))
                (h (max h *bar-height*)))
            (unless (and (= (client-x c) x) (= (client-y c) y) 
                         (= (client-w c) w) (= (client-h c) h))
              (client-x-set! c x)
              (client-y-set! c y)
              (client-w-set! c w)
              (client-h-set! c h)
              (x-move-resize-window display (client-window c) x y w h))))))))
