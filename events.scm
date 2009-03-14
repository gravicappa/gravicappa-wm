;(include "xlib/Xlib#.scm")

(define +wm-state+ #f)

(define (pickup-window display screen window)
  (let ((wa (x-get-window-attributes display window)))
    (unless (x-window-attributes-override-redirect? wa)
      (run-hook *manage-hook* display window wa screen))))

(define (manage-window display window wa screen)
  (display-log ";; managing window " window)
  (manage-client display (make-client* window wa screen)))

(define-x-event-handler (map-request display window parent send-event?)
	(unless (or send-event? (client-from-window* window))
    (pickup-window display (find-screen parent) window)))

(define-x-event-handler (mapping-notify display window ev request)
  (x-refresh-keyboard-mapping ev)
  (when (eq? request +mapping-keyboard+)
    ;(grab-keys display)
    #f
    ))

(define (handle-unmanaged-window display window x y width height border-width
                                 above value-mask detail)
  (let* ((set? (lambda (flag) (not (zero? (bitwise-and flag value-mask)))))
         (if-set (lambda (flag value)
                   (if (set? flag)
                       value
                       '()))))
    (x-configure-window display
                        window
                        x: (if-set +cwx+ x)
                        y: (if-set +cwy+ y)
                        width: (if-set +cw-width+ width)
                        height: (if-set +cw-height+ height)
                        border-width: (if-set +cw-border-width+ border-width)
                        sibling: (if-set +cw-sibling+ above)
                        stack-mode: (if-set +cw-stack-mode+ detail))))

(define-x-event-handler (configure-request display window x y width height
                                   border-width above value-mask detail)
  (let* ((c (client-from-window* window))
         (set? (lambda (flag) (not (zero? (bitwise-and flag value-mask)))))
         (if-set (lambda (flag value)
                   (if (set? flag)
                       value
                       '()))))
    (if c
        (let ((s (client-screen c)))
          (cond ((set? +cw-border-width+)
                 (client-border-set! c border-width))
                ((client-floating? c)
                 (if (set? +cwx+)
                     (client-x-set! c (+ (screen-x s) x)))
                 (if (set? +cwy+)
                     (client-y-set! c (+ (screen-y s) y)))
                 (if (set? +cw-width+)
                     (client-w-set! c width))
                 (if (set? +cw-height+)
                     (client-w-set! c height))
                 (center-client-on-screen-if-floating c)
                 (if (and (set? (bitwise-ior +cw-x+ +cw-y+))
                          (not (set? (bitwise-ior +cw-width+ +cw-height+))))
                     (configure-client display c))
                 (if (client-visible? c)
                     (x-move-resize-client (client-window c)
                                           (client-x c)
                                           (client-y c)
                                           (client-w c)
                                           (client-h c))))
                (else
                  (configure-client display c))))
        (handle-unmanaged-window display window x y width height border-width
                                 above value-mask detail))
    (x-sync display #f)))

(define-x-event-handler (destroy-notify display window)
  (let ((c (client-from-window* window)))
    (when c
      (run-hook *unmanage-hook* display c))))

(define-x-event-handler (unmap-notify display window)
  (let ((c (client-from-window* window)))
    (when c
      (run-hook *unmanage-hook* display c))))

(define-x-event-handler (property-notify display window atom state)
  (unless (eq? state +property-delete+)
    (let ((c (client-from-window* window)))
      (case atom
        ((+xa-wm-transient-for+) #f)
        ((+xa-wm-normal-hints+) (update-size-hints! c))
        ((+xa-wm-hints+) (update-wm-hints! c))
        ((+xa-wm-name+) #f)))))

(define-x-event-handler (configure-notify display window x y width height)
  (let ((s (find-screen window)))
    (when (and s (not (and (eq? width (screen-w s))
                           (eq? height (screen-h s)))))
      (screen-w-set! s width)
      (screen-h-set! s height)
      (run-hook *arrange-hook* display))))

(define-x-event-handler (enter-notify display window mode detail)
  (when (or (eq? mode +notify-normal+)
            (not (eq? detail +notify-inferior+))
            (find-screen window))
    (run-hook *focus-hook* display (client-from-window* window))))

(define-x-event-handler (focus-in display window)
  (when (and *selected* (not (eq? window (client-window *selected*))))
    (x-set-input-focus display
                       window
                       +revert-to-pointer-root+
                       +current-time+)))

(define-x-event-handler (button-press display window time)
  (run-hook *focus-hook* display (client-from-window* window))
  (x-allow-events display +replay-pointer+ time))

(define-x-event-handler (key-press display code state)
  #f)
