
(define (pickup-window display screen window)
  (unless (client-from-window* window)
    (let ((wa (x-get-window-attributes display window)))
      (unless (x-window-attributes-override-redirect? wa)
        (run-hook *manage-hook* display window wa screen)))))

(define (manage-window display window wa screen)
  (manage-client display (make-client* display window wa screen)))

(define-x-event-handler (map-request display window parent)
  (pickup-window display (find-screen parent) window))

(define-x-event-handler (mapping-notify display window ev request)
  (x-refresh-keyboard-mapping ev)
  (when (eq? request +mapping-keyboard+)
    (setup-window-bindings display (screen-root (current-screen)))))

(define (handle-unmanaged-window display window x y width height border-width
                                 above value-mask detail)
  (let ((if-set (lambda (flag value)
                  (if (not (zero? (bitwise-and flag value-mask)))
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
  (let ((c (client-from-window* window))
        (set? (lambda (flag) (not (zero? (bitwise-and flag value-mask))))))
    (if c
        (let ((s (client-screen c)))
          (cond ((set? +cw-border-width+)
                 (client-border-set! c border-width))
                ((or (client-floating? c))
                 (if (set? +cwx+)
                     (client-x-set! c (+ (screen-x s) x)))
                 (if (set? +cwy+)
                     (client-y-set! c (+ (screen-y s) y)))
                 (if (set? +cw-width+)
                     (client-w-set! c width))
                 (if (set? +cw-height+)
                     (client-h-set! c height))
                 (if (client-floating? c)
                     (center-client-on-screen c))
                 (if (and (set? (bitwise-ior +cwx+ +cwy+))
                          (not (set? (bitwise-ior +cw-width+ +cw-height+))))
                     (configure-client-window display c))
                 (if (client-visible? c)
                     (x-move-resize-window display
                                           (client-window c)
                                           (client-x c)
                                           (client-y c)
                                           (client-w c)
                                           (client-h c))))
                (else (configure-client-window display c))))
      (handle-unmanaged-window display window x y width height border-width
                               above value-mask detail))
    (x-sync display #f)))

(define-x-event-handler (destroy-notify display window)
  (let ((c (client-from-window* window)))
    (if c
        (run-hook *unmanage-hook* display c))))

(define-x-event-handler (unmap-notify send-event? event display window)
  (when (or send-event? (eq? event window))
    (let ((c (client-from-window* window)))
      (if c
          (run-hook *unmanage-hook* display c)))))

(define-x-event-handler (property-notify display window atom state)
  (unless (eq? state +property-delete+)
    (display-log "property-notify window:" window
                 " atom:" (x-get-atom-name display atom)
                 " state:" state)
    (let ((c (client-from-window* window)))
      (if c
          (cond ((eq? atom +xa-wm-transient-for+)
                 (unless (eq? (x-get-transient-for-hint display window)
                              +none+)
                   (client-floating?-set! c #t)
                   (run-hook *arrange-hook* display (client-screen c))
                   #f))
                ((eq? atom +xa-wm-normal-hints+)
                 (update-size-hints! display c))
                ((eq? atom +xa-wm-hints+)
                 (update-wm-hints! display c))
                ((or (eq? atom +xa-wm-name+)
                     (eq? atom (get-atom "_NET_WM_NAME")))
                 (update-title! c)))))))

(define-x-event-handler (configure-notify display event window
                                          x y width height)
  (let ((s (find-screen window)))
    (when (and s (not (and (eq? width (screen-w s))
                           (eq? height (screen-h s)))))
      (screen-w-set! s width)
      (screen-h-set! s height)
      (run-hook *arrange-hook* display s)
      (x-sync display #f))))

(define-x-event-handler (enter-notify display window mode detail)
  (if (or (and (eq? mode +notify-normal+)
               (not (eq? detail +notify-inferior+)))
          (find-screen window))
      (run-hook *focus-hook* display (client-from-window* window))))

(define-x-event-handler (focus-in display window)
  (if (and *selected* (not (eq? window (client-window *selected*))))
      (x-set-input-focus display
                         (client-window *selected*)
                         +revert-to-pointer-root+
                         +current-time+)))

(define-x-event-handler (button-press display window time)
  (run-hook *focus-hook* display (client-from-window* window))
  (x-allow-events display +replay-pointer+ time))

(define-x-event-handler (key-press display keycode state)
  (let ((keysym (x-keycode-to-keysym display (integer->char keycode) 0)))
    (run-hook *keypress-hook* display keysym state)))

(define-x-event-handler (expose display window count)
  ;; TODO: modeline window should be redrawn here if exists
  #f)
