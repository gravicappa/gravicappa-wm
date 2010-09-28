(define (pickup-window display screen window)
  (if (not (find-client window))
      (let ((wa (x-get-window-attributes display window)))
        (if (not (x-window-attributes-override-redirect? wa))
            (manage-window display window wa screen)))))

(define (manage-window display window wa screen)
  (manage-client (make-x-client window wa screen)))

(define-x-event-handler (map-request display window parent)
  (pickup-window display (find-screen parent) window))

(define-x-event-handler (mapping-notify display window ev request)
  (x-refresh-keyboard-mapping ev)
  (if (eq? request x#+mapping-keyboard+)
      (setup-window-bindings! (screen-root (current-screen)) bindings)))

(define (flag-set? flags mask) (= (bitwise-and flags mask) mask))

(define (handle-unmanaged-window display window x y width height border-width
                                 above value-mask detail)
  (let ((if-set (lambda (flag value)
                  (if (flag-set? value-mask flag)
                      value
                      '()))))
    (x-configure-window display
                        window
                        x: (if-set x#+cwx+ x)
                        y: (if-set x#+cwy+ y)
                        width: (if-set x#+cw-width+ width)
                        height: (if-set x#+cw-height+ height)
                        border-width: (if-set x#+cw-border-width+ border-width)
                        sibling: (if-set x#+cw-sibling+ above)
                        stack-mode: (if-set x#+cw-stack-mode+ detail))))

(define-x-event-handler (configure-request display window x y width height
                                           border-width above value-mask
                                           detail)
  (let ((c (find-client window))
        (set? (lambda (flag) (flag-set? value-mask flag))))
    (if (client? c)
        (let ((s (current-screen)))
          (cond ((set? x#+cw-border-width+)
                 (set-client-border! c border-width))
                ((client-floating? c)
                 (if (set? x#+cwx+)
                     (set-client-x! c (+ (screen-x s) x)))
                 (if (set? x#+cwy+)
                     (set-client-y! c (+ (screen-y s) y)))
                 (if (set? x#+cw-width+)
                     (set-client-w! c width))
                 (if (set? x#+cw-height+)
                     (set-client-h! c height))
                 (if (client-floating? c)
                     (center-client-on-screen! c))
                 (if (and (set? (bitwise-ior x#+cwx+ x#+cwy+))
                          (not (set? (bitwise-ior x#+cw-width+
                                                  x#+cw-height+))))
                     (configure-client-window! c))
                 (if (client-visible? c)
                     (x-move-resize-window display
                                           (client-window c)
                                           (client-x c)
                                           (client-y c)
                                           (client-w c)
                                           (client-h c))))
                (else (configure-client-window! c))))
        (handle-unmanaged-window display window x y width height border-width
                                 above value-mask detail))
    (x-sync display #f)))

(define-x-event-handler (destroy-notify display window)
  (let ((c (find-client window)))
    (if (client? c)
        (unmanage-client display c))))

(define-x-event-handler (unmap-notify send-event? event display window)
  (if (or send-event? (eq? event window))
      (let ((c (find-client window)))
        (if (client? c)
            (unmanage-client display c)))))

(define-x-event-handler (property-notify display window atom state)
  (if (not (eq? state x#+property-delete+))
      (begin
        (display-log 10
                     "property-notify window:" window
                     " atom:" (x-get-atom-name display atom)
                     " state:" state)
        (let ((c (find-client window)))
          (if (client? c)
              (cond
                ((eq? atom x#+xa-wm-transient-for+)
                 (if (not (eq? (x-get-transient-for-hint display window)
                               x#+none+))
                     (begin
                       (set-client-floating! c #t)
                       (arrange-screen display (current-screen)))
                     #f))
                ((eq? atom x#+xa-wm-normal-hints+)
                 (update-size-hints! c))
                ((eq? atom x#+xa-wm-hints+)
                 (update-wm-hints! c))
                ((or (eq? atom x#+xa-wm-name+)
                     (eq? atom (xatom "_NET_WM_NAME")))
                 (update-client-title! c))))))))

(define-x-event-handler (configure-notify display event window x y width
                                          height)
  (let ((s (find-screen window)))
    (if (and s (not (and (eq? width (screen-w s))
                         (eq? height (screen-h s)))))
        (begin
          (set-screen-w! s width)
          (set-screen-h! s height)
          (arrange-screen display s)
          (x-sync display #f)))))

(define-x-event-handler (enter-notify display window mode detail)
  (if (or (and (eq? mode x#+notify-normal+)
               (not (eq? detail x#+notify-inferior+)))
          (find-screen window))
      (focus-client display (find-client window))))

(define-x-event-handler (focus-in display window)
  (if (and (current-client)
           (not (eq? window (client-window (current-client)))))
      (x-set-input-focus display
                         (client-window (current-client))
                         x#+revert-to-pointer-root+
                         x#+current-time+)))

(define-x-event-handler (button-press display window time)
  (focus-client display (find-client window))
  (x-allow-events display x#+replay-pointer+ time))

(define-x-event-handler (key-press display keycode state)
  (let ((keysym (x-keycode-to-keysym display (integer->char keycode) 0)))
    (handle-keypress-event display keysym state)))
