(define-structure* client
  name window screen tags display class
  x y w h
  border old-border
  fixed? urgent? fullscreen? floating?
  basew baseh incw inch maxw maxh minw minh mina maxa)

(define *client-input-mask* (bitwise-ior +enter-window-mask+
                                         +focus-change-mask+
                                         +property-change-mask+
                                         +structure-notify-mask+))

(define (make-x-client disp window wa screen)
  (make-client tags: '()
               display: disp
               screen: screen
               window: window
               x: (x-window-attributes-x wa)
               y: (x-window-attributes-y wa)
               w: (x-window-attributes-width wa)
               h: (x-window-attributes-height wa)
               old-border: (x-window-attributes-border-width wa)))

(define (add-client! c stack)
  (set-cdr! stack (cons c (cdr stack))))

(define (remove-client! c stack)
  (set-cdr! stack (remove c (cdr stack))))

(define (move-client-to-top! c stack)
  (set-cdr! stack (cons c (remove c (cdr stack)))))

(define (client-wants-fullscreen? client)
  (and (= (client-w client) (screen-w (client-screen client)))
       (= (client-h client) (screen-h (client-screen client)))))

(define (fullscreenize-client! c)
  (set-client-border! c 0)
  (set-client-fullscreen?! c #t)
  (set-client-x! c (screen-x (client-screen c)))
  (set-client-y! c (screen-y (client-screen c))))

(define (hold-client-on-screen c x y w h proc)
  (let ((f (lambda (x w ax aw b)
             (max ax
                  (if (> (+ x w (* 2 b)) (+ ax aw))
                      (- (+ ax aw) w)
                      x))))
        (b (client-border c))
        (s (client-screen c)))
    (proc (f x w (screen-x s) (screen-w s) b)
          (f y h (screen-y s) (screen-h s) b))))

(define (center-client-on-rect! c rect)
  (let ((f (lambda (a1 a2 ib1 ib2)
             (if (> (+ (- a1 (vector-ref rect ib1)) a2) (vector-ref rect ib2))
                 (floor (+ (vector-ref rect ib1)
                           (/ (- (vector-ref rect ib2) a2) 2)))
                 a1)))
        (s (client-screen c)))
    (set-client-x! c (f (client-x c) (client-w c) 0 2))
    (set-client-y! c (f (client-y c) (client-h c) 1 3))))

(define (center-client-on-screen! c)
  (let ((s (client-screen c)))
    (center-client-on-rect! c (vector (screen-x s)
                                      (screen-y s)
                                      (screen-w s)
                                      (screen-h s)))))

(define (configure-client-window! c)
  (let ((ev (make-x-event-box))
        (win (client-window c))
        (disp (client-display c)))
    (set-x-configure-event-type! ev +configure-notify+)
    (set-x-configure-event-display! ev disp)
    (set-x-configure-event-window! ev win)
    (set-x-configure-event-event! ev win)
    (set-x-configure-event-x! ev (client-x c))
    (set-x-configure-event-y! ev (client-y c))
    (set-x-configure-event-width! ev (client-w c))
    (set-x-configure-event-height! ev (client-h c))
    (set-x-configure-event-border-width! ev (client-border c))
    (set-x-configure-event-above! ev +none+)
    (set-x-configure-event-override-redirect?! ev #f)
    (x-send-event disp win #f +structure-notify-mask+ ev)))

(define (hint-set? flag hints)
  (bitwise-and (x-size-hints-flags hints) flag))

(define (set-client-base-size! c hints)
  (cond ((hint-set? +p-base-size+ hints)
         (set-client-basew! c (x-size-hints-base-width hints))
         (set-client-baseh! c (x-size-hints-base-height hints)))
        ((hint-set? +p-min-size+ hints)
         (set-client-basew! c (x-size-hints-min-width hints))
         (set-client-baseh! c (x-size-hints-min-height hints)))
        (else (set-client-basew! c 0)
              (set-client-baseh! c 0))))

(define (set-client-inc! c hints)
  (cond ((hint-set? +p-resize-inc+ hints)
         (set-client-incw! c (x-size-hints-width-inc hints))
         (set-client-inch! c (x-size-hints-height-inc hints)))
        (else (set-client-incw! c 0)
              (set-client-inch! c 0))))

(define (set-client-max-size! c hints)
  (cond ((hint-set? +p-max-size+ hints)
         (set-client-maxw! c (x-size-hints-max-width hints))
         (set-client-maxh! c (x-size-hints-max-height hints)))
        (else (set-client-maxw! c 0)
              (set-client-maxh! c 0))))

(define (set-client-min-size! c hints)
  (cond ((hint-set? +p-min-size+ hints)
         (set-client-minw! c (x-size-hints-min-width hints))
         (set-client-minh! c (x-size-hints-min-height hints)))
        ((hint-set? +p-base-size+ hints)
         (set-client-minw! c (x-size-hints-base-width hints))
         (set-client-minh! c (x-size-hints-base-height hints)))
        (else (set-client-minw! c 0)
              (set-client-minh! c 0))))

(define (set-client-aspect! c hints)
  (cond ((hint-set? +p-aspect+ hints)
         (set-client-mina! c
                           (if (positive? (x-size-hints-min-aspect-y hints))
                               (/ (x-size-hints-min-aspect-x hints)
                                  (x-size-hints-min-aspect-y hints))
                             0))
         (set-client-maxa! c
                           (if (positive? (x-size-hints-max-aspect-y hints))
                               (/ (x-size-hints-max-aspect-x hints)
                                  (x-size-hints-max-aspect-y hints))
                             0)))
        (else (set-client-mina! c 0)
              (set-client-maxa! c 0))))

(define (update-size-hints! c)
  (let ((hints (x-get-wm-normal-hints (client-display c) (client-window c))))
    (set-client-base-size! c hints)
    (set-client-inc! c hints)
    (set-client-max-size! c hints)
    (set-client-min-size! c hints)
    (set-client-aspect! c hints)
    (set-client-fixed?! c
                        (and (positive? (client-maxw c))
                             (positive? (client-maxh c))
                             (positive? (client-minw c))
                             (positive? (client-minh c))
                             (= (client-maxw c) (client-minw c))
                             (= (client-maxh c) (client-minh c))))))

(define (update-wm-hints! c)
  ;; TODO: process urgency hint
  #f)

(define (update-title! c)
  (let ((strings (or (x-get-text-property-list (client-display c)
                                               (client-window c)
                                               (get-atom "_NET_WM_NAME"))
                     (x-get-text-property-list (client-display c)
                                               (client-window c)
                                               +xa-wm-name+))))
    (if (pair? strings)
        (set-client-name! c (car strings)))))

(define (grab-buttons! c)
  (let ((disp (client-display c))
        (mask (bitwise-ior +button-press-mask+ +button-release-mask+))
        (win (client-window c)))
    (x-ungrab-button disp +any-button+ +any-modifier+ (client-window c))
    (let loop ((i 1))
      (x-grab-button disp
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
  (let ((tr (x-get-transient-for-hint (client-display c) (client-window c))))
    (if (not (eq? tr +none+))
        (begin
          (set-client-floating?! c #t)
          (let ((parent (find-client tr)))
            (if parent
                (set-client-tags! c (client-tags parent))))))))

(define (manage-client c)
  (let ((s (client-screen c))
        (w (client-window c))
        (disp (client-display c)))
    (cond ((client-wants-fullscreen? c)
           (fullscreenize-client! c))
          (else (set-client-border! c *border-width*)
                (hold-client-on-screen
                  c (client-x c) (client-y c) (client-w c) (client-h c)
                  (lambda (x y)
                    (set-client-x! c x)
                    (set-client-y! c y)))))
    (x-configure-window disp w border-width: (client-border c))
    (x-set-window-border disp w (get-colour disp s *border-colour*))
    (configure-client-window! c)
    (update-size-hints! c)
    (x-select-input disp w *client-input-mask*)
    (x-ungrab-button disp +any-button+ +any-modifier+ w)
    (update-title! c)
    (process-transient-for-hint! c)
    (set-client-class! c (x-get-class-hint disp w))
    (display-log "client class: " (client-class c) " name: " (client-name c))
    (run-hook *rules-hook* c)
    (if (null? (client-tags c))
        (set-client-tags! c (list (current-view))))
    (run-hook *update-tag-hook*)
    (set-client-floating?! c (or (client-floating? c)
                                 (client-fixed? c)
                                 (client-fullscreen? c)))
    (if (client-floating? c)
        (x-raise-window disp w))
    (add-client! c (screen-clients s))
    (if (not (memq c (screen-focus-stack s)))
        (add-client! c (screen-focus-stack s)))
    (x-move-resize-window disp
                          w
                          (+ (client-x c) (* 2 (screen-w s)))
                          (client-y c)
                          (client-w c)
                          (client-h c))
    (x-map-window disp w)
    (set-x-window-state! disp w (get-atom "WM_STATE") +normal-state+)
    (arrange-screen disp s)))

(define (unmanage-client disp c)
  (let ((w (client-window c))
        (s (client-screen c)))
    (dynamic-wind
      (lambda ()
        (x-grab-server disp)
        (set-x-error-handler! (lambda (disp ev) #t)))
      (lambda ()
        (x-configure-window disp w border-width: (client-old-border c))
        (remove-client! c (screen-clients s))
        (remove-client! c (screen-focus-stack s))
        (x-ungrab-button disp +any-button+ +any-modifier+ w)
        (set-x-window-state! disp
                             w
                             (get-atom "WM_STATE")
                             +withdrawn-state+))
      (lambda ()
        (x-sync disp #f)
        (set-x-error-handler! wm-error-handler)
        (x-ungrab-server disp)))
    (run-hook *update-tag-hook*)
    (arrange-screen disp (client-screen c))
    (x-sync disp #f)))

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

(define (respect-client-hints c w h)
  (let* ((border (client-border c))
         (minw (client-minw c))
         (basew (client-basew c))
         (maxw (client-maxw c))
         (minh (client-minh c))
         (baseh (client-baseh c))
         (maxh (client-maxh c))
         (incw (client-incw c))
         (inch (client-inch c))
         (mina (client-mina c))
         (maxa (client-maxa c))
         (base-is-min? (and (= basew minw) (= baseh minh)))
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

(define (clamp dim size head width)
  (let ((dim (if (> dim (+ head width))
                 (- (+ head width) size)
                 dim)))
    (if (< (+ dim size) head)
        head
        dim)))

(define (resize-client! c x y w h)
  (let* ((s (client-screen c))
         (sx (screen-x s))
         (sy (screen-y s))
         (sw (screen-w s))
         (sh (screen-h s))
         (border (client-border c)))
    (call-with-values
      (lambda () (respect-client-hints c w h))
      (lambda (w h)
        (if (and (positive? w) (positive? h))
            (let ((x (floor (clamp x (+ w (* 2 border)) sx sw)))
                  (y (floor (clamp y (+ h (* 2 border)) sy sh)))
                  (w (floor (max w *bar-height*)))
                  (h (floor (max h *bar-height*))))
              (if (not (and (= (client-x c) x) (= (client-y c) y)
                            (= (client-w c) w) (= (client-h c) h)))
                  (begin
                    (set-client-x! c x)
                    (set-client-y! c y)
                    (set-client-w! c w)
                    (set-client-h! c h)
                    (x-configure-window (client-display c)
                                        (client-window c)
                                        x: x
                                        y: y
                                        width: w
                                        height: h
                                        border-width: (client-border c))
                    (configure-client-window! c)
                    (x-sync (client-display c) #f)))))))))

(define (client-has-delete-proto? c)
  (if c
      (member (get-atom "WM_DELETE_WINDOW")
              (x-get-wm-protocols (client-display c) (client-window c)))))

(define (send-client-kill-message c)
  (let ((ev (make-x-event-box))
        (win (client-window c))
        (disp (client-display c)))
    (set-x-client-message-event-type! ev +client-message+)
    (set-x-client-message-event-window! ev win)
    (set-x-client-message-event-message-type! ev (get-atom "WM_PROTOCOLS"))
    (set-x-client-message-event-format! ev 32)
    (set-x-client-message-event-data-l! ev 0 (get-atom "WM_DELETE_WINDOW"))
    (set-x-client-message-event-data-l! ev 1 +current-time+)
    (x-send-event disp win #f +no-event-mask+ ev)))

(define (kill-client! c)
  (if c
      (if (client-has-delete-proto? c)
          (send-client-kill-message c)
          (x-kill-client (client-display c) (client-window c)))))
