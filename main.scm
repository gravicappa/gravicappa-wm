(define *user-config-file* "~/.gravicappa-wm.scm")

;;; defaults
(define border-colour #xf0e7e7)
(define selected-border-colour #xf09000)
(define border-width 1)
(define borders (vector 0 16 0 0))
(define gap 1)
(define initial-tag "First")
(define current-tag initial-tag)

(bind-key x#+mod4-mask+ "Return" (lambda () (shell-command "xterm&")))
(bind-key x#+mod4-mask+ "h" focus-left)
(bind-key x#+mod4-mask+ "j" focus-before)
(bind-key x#+mod4-mask+ "k" focus-after)
(bind-key x#+mod4-mask+ "l" focus-right)
(bind-key x#+mod4-mask+ "o" (lambda () (zoom-mwin current-mwin)))
(bind-key x#+mod4-mask+ "c" (lambda () (kill-mwin current-mwin)))
(bind-key x#+mod4-mask+ "1" (lambda () (focus-nth 1)))
(bind-key x#+mod4-mask+ "2" (lambda () (focus-nth 2)))
(bind-key x#+mod4-mask+ "3" (lambda () (focus-nth 3)))
(bind-key x#+mod4-mask+ "4" (lambda () (focus-nth 4)))
(bind-key x#+mod4-mask+ "5" (lambda () (focus-nth 5)))
(bind-key x#+mod4-mask+ "6" (lambda () (focus-nth 6)))
(bind-key x#+mod4-mask+ "7" (lambda () (focus-nth 7)))
(bind-key x#+mod4-mask+ "8" (lambda () (focus-nth 8)))
(bind-key x#+mod4-mask+ "9" (lambda () (focus-nth 9)))
(bind-key x#+mod4-mask+ "0" (lambda () (focus-nth 10)))

(define (shutdown-hook) #f)
(define (update-tag-hook) #f)
(define (mwin-create-hook mwin classname) #f)
(define (focus-hook) #f)
(define (tag-hook c tag) #t)
(define (untag-hook c tag) #t)

(define current-mwin #f)
(define current-display (lambda () #f))
(define atoms (make-table))

(define (wm-error-handler dpy ev)
  (let ((error-code (char->integer (x-error-event-error-code ev)))
        (request-code (char->integer (x-error-event-request-code ev))))
    (display-log 3 "X11 ERROR: code=" error-code " request-code=" request-code)
    (if (not (or (= error-code x#+bad-window+)
                 (and (= error-code x#+bad-match+)
                      (member request-code (list x#+x-set-input-focus+
                                                 x#+x-configure-window+)))
                 (and (= error-code x#+bad-drawable+)
                      (member request-code (list x#+x-poly-text8+
                                                 x#+x-poly-fill-rectangle+
                                                 x#+x-poly-segment+
                                                 x#+x-copy-area+)))
                 (and (= error-code x#+bad-access+)
                      (member request-code (list x#+x-grab-button+
                                                 x#+x-grab-key+)))))
        (x-default-error-handler dpy ev))))

(define (atom-set! dpy name)
  (table-set! atoms name (x-intern-atom dpy name #f)))

(define (xatom name) (table-ref atoms name))

(define (init-atoms dpy)
  (for-each (lambda (a) (table-set! atoms a (x-intern-atom dpy a #f)))
            '("WM_STATE"
              "WM_DELETE_WINDOW"
              "WM_PROTOCOLS"
              "_NET_WM_NAME"
              "_NET_SUPPORTED"
              "_NET_WM_STATE"
              "_NET_WM_STATE_FULLSCREEN")))

(define (nop-handler _) #t)

(define (handle-x11-event ev)
  ((table-ref x11-event-handlers (x-any-event-type ev) nop-handler) ev))

(define (main-loop)
  (let ((dpy (current-display)))
    (x-call-with-x11-events
     dpy
     (lambda ()
       (let loop ()
         (cond ((positive? (x-pending dpy))
                (handle-x11-event (x-next-event dpy))
                (loop))))
       #t)))
  (main-loop))

(define (load-user-config)
  (let ((cfg (getenv "GRAVICAPPA_WM_CFG" *user-config-file*)))
    (if (file-exists? cfg)
        (load cfg))))

(define (main . args)
  (dynamic-wind
    (lambda ()
      (set! current-display (let ((dpy (x-open-display #f)))
                              (lambda () dpy)))
      (if (not (current-display))
          (error "Unable to open display"))
      (init-atoms (current-display))
      (set-x-error-handler! wm-error-handler)
      (init-all-screens (current-display))
      (load-user-config)
      (setup-bindings)
      (pickup-windows (current-display)))
    (lambda ()
      (x-sync (current-display) #f)
      (main-loop))
    (lambda ()
      (shutdown-hook)
      (set! *screens* (vector))
      (set! current-display (lambda () #f))
      (##gc))))
