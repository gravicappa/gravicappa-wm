(define-x-event-handler (map-request display window parent)
  (if (not (find-mwin window))
      (let ((wa (x-get-window-attributes display window)))
        (if (not (x-window-attributes-override-redirect? wa))
            (manage-mwin window
                         (make-mwin window wa (find-screen parent)))))))

(define-x-event-handler (mapping-notify display window ev request)
  (x-refresh-keyboard-mapping ev)
  (if (= request x#+mapping-keyboard+)
      (setup-window-bindings
       display (screen-root (current-screen)) bindings)))

(define (handle-unmanaged-window display window x y width height border-width
                                 above value-mask detail)
  (define (if-set flag value)
    (if (flag-set? value-mask flag)
        value
        '()))
  (x-configure-window display
                      window
                      x: (if-set x#+cwx+ x)
                      y: (if-set x#+cwy+ y)
                      width: (if-set x#+cw-width+ width)
                      height: (if-set x#+cw-height+ height)
                      border-width: (if-set x#+cw-border-width+ border-width)
                      sibling: (if-set x#+cw-sibling+ above)
                      stack-mode: (if-set x#+cw-stack-mode+ detail)))

(define-x-event-handler (configure-request display window x y width height
                                           border-width above value-mask
                                           detail)
  (let ((c (find-mwin window)))
    (define (set? flag) (flag-set? value-mask flag))
    (if (mwin? c)
        (let ((s (current-screen)))
          (cond ((set? x#+cw-border-width+)
                 (set-mwin-border! c border-width))
                ((mwin-floating? c)
                 (if (set? x#+cwx+)
                     (set-mwin-x! c (+ (screen-x s) x)))
                 (if (set? x#+cwy+)
                     (set-mwin-y! c (+ (screen-y s) y)))
                 (if (set? x#+cw-width+)
                     (set-mwin-w! c width))
                 (if (set? x#+cw-height+)
                     (set-mwin-h! c height))
                 (center-mwin-on-screen c)
                 (if (and (set? (bitwise-ior x#+cwx+ x#+cwy+))
                          (not (set? (bitwise-ior x#+cw-width+
                                                  x#+cw-height+))))
                     (configure-mwin-window c))
                 (if (mwin-visible? c)
                     (x-move-resize-window display
                                           (mwin-window c)
                                           (mwin-x c)
                                           (mwin-y c)
                                           (mwin-w c)
                                           (mwin-h c))))
                (else (configure-mwin-window c))))
        (handle-unmanaged-window display window x y width height border-width
                                 above value-mask detail))
    (x-sync display #f)))

(define-x-event-handler (destroy-notify display window)
  (let ((c (find-mwin window)))
    (if (mwin? c)
        (unmanage-mwin display c))))

(define-x-event-handler (unmap-notify send-event? event display window)
  (if (or send-event? (= event window))
      (let ((c (find-mwin window)))
        (if (mwin? c)
            (unmanage-mwin display c)))))

(define-x-event-handler (property-notify display window atom state)
  (if (not (= state x#+property-delete+))
      (begin
        (display-log 10
                     "property-notify window:" window
                     " atom:" (x-get-atom-name display atom)
                     " state:" state)
        (let ((c (find-mwin window)))
          (if (mwin? c)
              (cond
                ((= atom x#+xa-wm-transient-for+)
                 (if (not (= (x-get-transient-for-hint display window)
                             x#+none+))
                     (begin
                       (set-mwin-floating! c #t)
                       (arrange-screen display (current-screen)))
                     #f))
                ((= atom x#+xa-wm-normal-hints+)
                 (update-size-hints c)
                 (arrange-screen display (current-screen)))
                ((= atom x#+xa-wm-hints+)
                 (update-wm-hints c))
                ((or (= atom x#+xa-wm-name+)
                     (= atom (xatom "_NET_WM_NAME")))
                 (update-mwin-title c))
                ;((= atom (xatom "WM_STATE")) (update-mwin-state c))
                (else
                  ;(pp `(property-notify ,atom of ,(table->list atoms)))
                  #t)))))))

(define-x-event-handler (configure-notify display event window x y width
                                          height)
  (let ((s (find-screen window)))
    (cond ((and s (not (and (= x (screen-x s))
                            (= y (screen-y s))
                            (= width (screen-w s))
                            (= height (screen-h s)))))
           (set-screen-x! s x)
           (set-screen-y! s y)
           (set-screen-w! s width)
           (set-screen-h! s height)
           (arrange-screen display s)
           (x-sync display #f)))))

(define-x-event-handler (enter-notify display window mode detail)
  (if (or (and (= mode x#+notify-normal+)
               (not (= detail x#+notify-inferior+)))
          (find-screen window))
      (focus-mwin display (find-mwin window))))

(define-x-event-handler (focus-in display window)
  (if (and current-mwin
           (not (eq? window (mwin-window current-mwin))))
      (x-set-input-focus display
                         (mwin-window current-mwin)
                         x#+revert-to-pointer-root+
                         x#+current-time+)))

(define-x-event-handler (button-press display window time)
  (focus-mwin display (find-mwin window))
  (x-allow-events display x#+replay-pointer+ time))

(define-x-event-handler (key-press display keycode state)
  (let ((keysym (x-keycode-to-keysym display (integer->char keycode) 0)))
    (handle-keypress-event display keysym state)))

(define-x-event-handler (client-message window message-type data-l)
  (let ((c (find-mwin window)))
    (cond ((not (mwin? c)) #f)
          ((= message-type (xatom "_NET_WM_STATE"))
           (let* ((fs (xatom "_NET_WM_STATE_FULLSCREEN")))
             (if (or (= (u32vector-ref data-l 1) fs)
                     (= (u32vector-ref data-l 2) fs))
                 (set-fullscreen c (or (= (u32vector-ref data-l 0) 1)
                                       (and (= (u32vector-ref data-l 0) 2)
                                            (not (mwin-fullscreen? c)))))))))))
