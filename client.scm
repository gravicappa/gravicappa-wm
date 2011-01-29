(define-record-type client
  (make-client window x y w h tags old-border)
  client?
  (name client-name set-client-name!)
  (window client-window)
  (tags client-tags set-client-tags!)
  (class client-class set-client-class!)
  (x client-x set-client-x!)
  (y client-y set-client-y!)
  (w client-w set-client-w!)
  (h client-h set-client-h!)
  (border client-border set-client-border!)
  (old-border client-old-border)
  (fixed? client-fixed? set-client-fixed!)
  (urgent? client-urgent? set-client-urgent!)
  (fullscreen? client-fullscreen? set-client-fullscreen!)
  (floating? client-floating? set-client-floating!)
  (basew client-basew set-client-basew!)
  (baseh client-baseh set-client-baseh!)
  (incw client-incw set-client-incw!)
  (inch client-inch set-client-inch!)
  (maxw client-maxw set-client-maxw!)
  (maxh client-maxh set-client-maxh!)
  (maxa client-maxa set-client-maxa!)
  (minw client-minw set-client-minw!)
  (minh client-minh set-client-minh!)
  (mina client-mina set-client-mina!))

(define screen-edge-width 32)
(define +client-input-mask+ (bitwise-ior x#+enter-window-mask+
                                         x#+focus-change-mask+
                                         x#+property-change-mask+
                                         x#+structure-notify-mask+))

(define (make-x-client window wa screen)
  (make-client window
               (x-window-attributes-x wa)
               (x-window-attributes-y wa)
               (max (x-window-attributes-width wa) 0)
               (max (x-window-attributes-height wa) 0)
               '()
               (x-window-attributes-border-width wa)))

(define (add-client! c stack)
  (set-cdr! stack (cons c (remove c (cdr stack)))))

(define (remove-client! c stack)
  (set-cdr! stack (remove c (cdr stack))))

(define (move-client-to-top! c stack)
  (set-cdr! stack (cons c (remove c (cdr stack)))))

(define (client-wants-fullscreen? client)
  (and (= (client-w client) (screen-w (current-screen)))
       (= (client-h client) (screen-h (current-screen)))))

(define (fullscreenize-client! c)
  (set-client-border! c 0)
  (set-client-fullscreen! c #t)
  (set-client-x! c (screen-x (current-screen)))
  (set-client-y! c (screen-y (current-screen))))

(define (keep-rect-on-screen x y w h b s ret)
  (let* ((pad screen-edge-width)
         (f (lambda (x w sx sw b)
              (cond ((< (+ x w (* 2 b)) (+ sx pad)) (- (+ pad sx) w (* 2 b)))
                    ((> (- (+ x pad) b) (+ sx sw)) (- (+ sx sw) b pad))
                    (else x)))))
    (ret (f x w (screen-x s) (screen-w s) b)
         (f y h (screen-y s) (screen-h s) b))))

(define (center-client-on-rect! c rect)
  (let ((f (lambda (a1 a2 ib1 ib2)
             (if (> (+ (- a1 (vector-ref rect ib1)) a2) (vector-ref rect ib2))
                 (floor (+ (vector-ref rect ib1)
                           (/ (- (vector-ref rect ib2) a2) 2)))
                 a1)))
        (s (current-screen)))
    (set-client-x! c (f (client-x c) (client-w c) 0 2))
    (set-client-y! c (f (client-y c) (client-h c) 1 3))))

(define (center-client-on-screen! c)
  (let ((s (current-screen)))
    (center-client-on-rect! c (vector (screen-x s)
                                      (screen-y s)
                                      (screen-w s)
                                      (screen-h s)))))

(define (configure-client-window! c)
  (let ((ev (make-x-event-box))
        (win (client-window c)))
    (set-x-configure-event-type! ev x#+configure-notify+)
    (set-x-configure-event-display! ev (current-display))
    (set-x-configure-event-window! ev win)
    (set-x-configure-event-event! ev win)
    (set-x-configure-event-x! ev (client-x c))
    (set-x-configure-event-y! ev (client-y c))
    (set-x-configure-event-width! ev (client-w c))
    (set-x-configure-event-height! ev (client-h c))
    (set-x-configure-event-border-width! ev (client-border c))
    (set-x-configure-event-above! ev x#+none+)
    (set-x-configure-event-override-redirect! ev #f)
    (x-send-event (current-display) win #f x#+structure-notify-mask+ ev)))

(define (hint-set? flag hints)
  (bitwise-and (x-size-hints-flags hints) flag))

(define (set-client-base-size! c hints)
  (cond ((hint-set? x#+p-base-size+ hints)
         (set-client-basew! c (x-size-hints-base-width hints))
         (set-client-baseh! c (x-size-hints-base-height hints)))
        ((hint-set? x#+p-min-size+ hints)
         (set-client-basew! c (x-size-hints-min-width hints))
         (set-client-baseh! c (x-size-hints-min-height hints)))
        (else (set-client-basew! c 0)
              (set-client-baseh! c 0))))

(define (set-client-inc! c hints)
  (cond ((hint-set? x#+p-resize-inc+ hints)
         (set-client-incw! c (x-size-hints-width-inc hints))
         (set-client-inch! c (x-size-hints-height-inc hints)))
        (else (set-client-incw! c 0)
              (set-client-inch! c 0))))

(define (set-client-max-size! c hints)
  (cond ((hint-set? x#+p-max-size+ hints)
         (set-client-maxw! c (x-size-hints-max-width hints))
         (set-client-maxh! c (x-size-hints-max-height hints)))
        (else (set-client-maxw! c 0)
              (set-client-maxh! c 0))))

(define (set-client-min-size! c hints)
  (cond ((hint-set? x#+p-min-size+ hints)
         (set-client-minw! c (x-size-hints-min-width hints))
         (set-client-minh! c (x-size-hints-min-height hints)))
        ((hint-set? x#+p-base-size+ hints)
         (set-client-minw! c (x-size-hints-base-width hints))
         (set-client-minh! c (x-size-hints-base-height hints)))
        (else (set-client-minw! c 0)
              (set-client-minh! c 0))))

(define (set-client-aspect! c hints)
  (cond ((hint-set? x#+p-aspect+ hints)
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
  (let ((hints (x-get-wm-normal-hints (current-display) (client-window c))))
    (set-client-base-size! c hints)
    (set-client-inc! c hints)
    (set-client-max-size! c hints)
    (set-client-min-size! c hints)
    (set-client-aspect! c hints)
    (set-client-fixed! c
                       (and (positive? (client-maxw c))
                            (positive? (client-maxh c))
                            (positive? (client-minw c))
                            (positive? (client-minh c))
                            (= (client-maxw c) (client-minw c))
                            (= (client-maxh c) (client-minh c))))))

(define (update-wm-hints! c)
  ;; TODO: process urgency hint
  #f)

(define (update-client-title! c)
  (let ((strings (or (x-get-text-property-list (current-display)
                                               (client-window c)
                                               (xatom "_NET_WM_NAME"))
                     (x-get-text-property-list (current-display)
                                               (client-window c)
                                               x#+xa-wm-name+))))
    (if (pair? strings)
        (set-client-name! c (car strings)))))

(define (grab-buttons! c)
  (let ((dpy (current-display))
        (mask (bitwise-ior x#+button-press-mask+ x#+button-release-mask+))
        (win (client-window c)))
    (x-ungrab-button dpy x#+any-button+ x#+any-modifier+ (client-window c))
    (do ((i 0 (+ i 1)))
        ((= i 32))
      (x-grab-button dpy
                     i
                     x#+any-modifier+
                     win
                     #f
                     mask
                     x#+grab-mode-sync+
                     x#+grab-mode-async+
                     x#+none+
                     x#+none+))))

(define (process-transient-for-hint! c)
  (let ((tr (x-get-transient-for-hint (current-display) (client-window c))))
    (if (not (eq? tr x#+none+))
        (begin
          (set-client-floating! c #t)
          (let ((parent (find-client tr)))
            (if parent
                (set-client-tags! c (client-tags parent))))))))

(define (manage-client c)
  (pp `(manage-client ,c))
  (let ((s (current-screen))
        (dpy (current-display))
        (w (client-window c)))
    (cond ((client-wants-fullscreen? c)
           (fullscreenize-client! c))
          (else (set-client-border! c (border-width))
                (keep-rect-on-screen
                  (client-x c) (client-y c) (client-w c) (client-h c)
                  (client-border c) (current-screen)
                  (lambda (x y)
                    (set-client-x! c x)
                    (set-client-y! c y)))))
    (x-configure-window dpy w border-width: (client-border c))
    (x-set-window-border dpy w (get-colour dpy s (border-colour)))
    (configure-client-window! c)
    (update-size-hints! c)
    (x-select-input dpy w +client-input-mask+)
    (x-ungrab-button dpy x#+any-button+ x#+any-modifier+ w)
    (update-client-title! c)
    (process-transient-for-hint! c)
    (client-create-hook c (x-get-class-hint dpy w))
    (if (null? (client-tags c))
        (set-client-tags! c (list (current-view))))
    (update-tag-hook)
    (set-client-floating! c (or (client-floating? c)
                                (client-fixed? c)
                                (client-fullscreen? c)))
    (x-raise-window dpy w)
    (add-client! c (screen-clients s))
    (if (not (memq c (screen-stack s)))
        (add-client! c (screen-stack s)))
    (x-move-resize-window dpy
                          w
                          (+ (client-x c) (* 2 (screen-w s)))
                          (client-y c)
                          (client-w c)
                          (client-h c))
    (x-map-window dpy w)
    (set-x-window-state! dpy w (xatom "WM_STATE") x#+normal-state+)
    (arrange-screen dpy s)))

(define (unmanage-client dpy c)
  (let ((w (client-window c))
        (s (current-screen)))
    (dynamic-wind
      (lambda ()
        (x-grab-server dpy)
        (set-x-error-handler! (lambda (dpy ev) #t)))
      (lambda ()
        (x-configure-window dpy w border-width: (client-old-border c))
        (remove-client! c (screen-clients s))
        (remove-client! c (screen-stack s))
        (x-ungrab-button dpy x#+any-button+ x#+any-modifier+ w)
        (set-x-window-state! dpy w (xatom "WM_STATE") x#+withdrawn-state+))
      (lambda ()
        (x-sync dpy #f)
        (set-x-error-handler! wm-error-handler)
        (x-ungrab-server dpy)))
    (update-tag-hook)
    (arrange-screen dpy (current-screen))
    (x-sync dpy #f)))

(define (arrange-dimension dim dmin base dmax inc base-is-min?)
  (let ((minimize (lambda (dim) (max dim 1)))
        (cut-base (lambda (dim when?) (if when? (- dim base) dim)))
        (adjust-inc (lambda (dim)
                      (if (positive? inc) (- dim (modulo dim inc)) dim)))
        (restore-base (lambda (dim) (+ dim base)))
        (clamp (lambda (dim) (if (positive? dmax) (min dim dmax) dim))))
    (floor (clamp (max (restore-base (cut-base dim base-is-min?)) dmin)))))

(define (adjust-aspect w h mina maxa ret)
  (if (and (positive? mina) (positive? maxa))
      (cond ((> (/ w h) maxa) (ret (* h maxa) h))
            ((< (/ w h) mina) (ret w (/ w mina)))
            (else (ret w h)))
      (ret w h)))

(define (apply-client-hints c w h ret)
  (let* ((border (client-border c))
         (basew (client-basew c))
         (maxw (client-maxw c))
         (minw (client-minw c))
         (incw (client-incw c))
         (baseh (client-baseh c))
         (maxh (client-maxh c))
         (minh (client-minh c))
         (inch (client-inch c))
         (maxa (client-maxa c))
         (mina (client-mina c))
         (base=min? (and (= basew minw) (= baseh minh)))
         (size-or-base (lambda (v base)
                         (let ((v (max v 1)))
                           (if base=min?
                               v
                               (- v base))))))
    (adjust-aspect
      (size-or-base w basew) (size-or-base h baseh) mina maxa
      (lambda (cw ch)
        (ret
          (arrange-dimension cw minw basew maxw incw base=min?)
          (arrange-dimension ch minh baseh maxh inch base=min?))))))

(define (clamp v size start end)
  (let ((v (if (> v (+ start end))
               (- (+ start end) size)
               v)))
    (if (< (+ v size) start)
        start
        v)))

(define (resize-client! c x y w h)
  (let* ((s (current-screen))
         (sx (screen-x s))
         (sy (screen-y s))
         (sw (screen-w s))
         (sh (screen-h s))
         (border (client-border c)))
    (apply-client-hints
      c w h
      (lambda (w h)
        (if (and (positive? w) (positive? h))
            (let ((x (floor (clamp x (+ w (* 2 border)) sx sw)))
                  (y (floor (clamp y (+ h (* 2 border)) sy sh)))
                  (w (floor (max w (bar-height))))
                  (h (floor (max h (bar-height)))))
              (if (not (and (= (client-x c) x) (= (client-y c) y)
                            (= (client-w c) w) (= (client-h c) h)))
                  (begin
                    (set-client-x! c x)
                    (set-client-y! c y)
                    (set-client-w! c w)
                    (set-client-h! c h)
                    (x-configure-window (current-display)
                                        (client-window c)
                                        x: x
                                        y: y
                                        width: w
                                        height: h
                                        border-width: (client-border c))
                    (configure-client-window! c)
                    (x-sync (current-display) #f)))))))))

(define (client-has-delete-proto? c)
  (if c
      (member (xatom "WM_DELETE_WINDOW")
              (x-get-wm-protocols (current-display) (client-window c)))))

(define (send-client-kill-message c)
  (let ((ev (make-x-event-box))
        (win (client-window c)))
    (set-x-client-message-event-type! ev x#+client-message+)
    (set-x-client-message-event-window! ev win)
    (set-x-client-message-event-message-type! ev (xatom "WM_PROTOCOLS"))
    (set-x-client-message-event-format! ev 32)
    (set-x-client-message-event-data-l! ev 0 (xatom "WM_DELETE_WINDOW"))
    (set-x-client-message-event-data-l! ev 1 x#+current-time+)
    (x-send-event (current-display) win #f x#+no-event-mask+ ev)))

(define (kill-client! c)
  (if c
      (if (client-has-delete-proto? c)
          (send-client-kill-message c)
          (x-kill-client (current-display) (client-window c)))))
