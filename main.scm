(define *user-config-file* "~/.gravicappa-wm.scm")

;;; defaults
(define border-colour #xf0f0a0)
(define selected-border-colour #x00af00)
(define border-width 1)
(define borders (vector 0 16 0 0))
(define initial-tag "First")

(bind-key x#+mod4-mask+ "Return" (lambda () (shell-command "xterm&")))
(bind-key x#+mod4-mask+ "h" focus-left)
(bind-key x#+mod4-mask+ "j" focus-before)
(bind-key x#+mod4-mask+ "k" focus-after)
(bind-key x#+mod4-mask+ "l" focus-right)
(bind-key x#+mod4-mask+ "o" (lambda () (zoom-client (current-client))))
(bind-key x#+mod4-mask+ "c" (lambda () (kill-client! (current-client))))
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

(define shutdown-hook (lambda () #f))
(define update-tag-hook (lambda () #f))
(define client-create-hook (lambda (client classname) #f))
(define focus-hook (lambda () #f))

(define current-client (lambda () #f))
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

(define (init-atoms!)
  (for-each (lambda (a) (atom-set! (current-display) a))
            '("WM_STATE"
              "WM_DELETE_WINDOW"
              "WM_PROTOCOLS"
              "_NET_WM_NAME"
              "_NET_SUPPORTED")))

(define (init-error-handler!) (set-x-error-handler! wm-error-handler))
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
       (##gc)
       #t)))
  (main-loop))

(define (load-user-config!)
  (if (file-exists? *user-config-file*)
      (load *user-config-file*)))

(define (main . args)
  (dynamic-wind
    (lambda ()
      (set! current-display (let ((dpy (x-open-display #f)))
                              (lambda () dpy)))
      (if (not (current-display))
          (error "Unable to open display"))
      (init-atoms!)
      (init-error-handler!)
      (init-all-screens!)
      (load-user-config!)
      (setup-bindings!)
      (pickup-windows!))
    (lambda ()
      (x-sync (current-display) #f)
      (main-loop))
    (lambda ()
      (shutdown-hook)
      (set! *screens* (vector))
      (set! current-display (lambda () #f))
      (##gc))))
