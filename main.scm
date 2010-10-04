(define *user-config-file* "~/.uwm.scm")

;;; defaults
(define border-colour (make-parameter #xf0f0a0))
(define selected-border-colour (make-parameter #x00af00))
(define border-width (make-parameter 2))
(define bar-height (make-parameter 16))
(define initial-view (make-parameter "gravicappa-wm"))

(bind-key x#+mod4-mask+ "Return" (lambda () (shell-command "xterm&")))
(bind-key x#+mod4-mask+ "h" focus-left)
(bind-key x#+mod4-mask+ "j" focus-before)
(bind-key x#+mod4-mask+ "k" focus-after)
(bind-key x#+mod4-mask+ "l" focus-right)
(bind-key x#+mod4-mask+ "a" focus-previous)
(bind-key x#+mod4-mask+ "o" (lambda () (zoom-client (current-client))))
(bind-key x#+mod4-mask+ "c" (lambda () (kill-client! (current-client))))

(define shutdown-hook (lambda () #f))
(define update-tag-hook (lambda () #f))
(define client-create-hook (lambda (client classname) #f))

(define current-client (make-parameter #f))
(define current-display (make-parameter #f))

(define *atoms* (make-table))

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
  (table-set! *atoms* name (x-intern-atom dpy name 0)))

(define (xatom name)
  (table-ref *atoms* name #f))

(define (init-atoms!)
  (for-each (lambda (a) (atom-set! (current-display) a))
            '("WM_STATE"
              "WM_DELETE_WINDOW"
              "WM_PROTOCOLS"
              "_NET_WM_NAME"
              "_NET_SUPPORTED")))

(define (init-error-handler!)
  (set-x-error-handler! wm-error-handler))

(define (handle-x11-event ev)
  (let ((proc (table-ref x11-event-handlers (x-any-event-type ev) #f)))
    (if proc
        (proc ev)
        ;(display-log 2 ";; unhandled event " (x-any-event-type ev))
        )))

(define (run-deferred)
  (let ((thunk (thread-receive 0 #f)))
    (if (procedure? thunk)
        (begin
          (thunk)
          (run-deferred)))))

(define (process-x11-events dpy)
  (x-call-with-x11-events
    dpy
    (lambda ()
      (let loop ()
        (if (positive? (x-pending dpy))
            (begin
              (handle-x11-event (x-next-event dpy))
              (loop))))
      (run-deferred)
      (##gc)
      #t)))

(define (main-loop)
  (process-x11-events (current-display))
  (main-loop))

(define (load-user-config!)
  (if (file-exists? *user-config-file*)
      (load *user-config-file*)))

(define (init!)
  (init-atoms!)
  (init-error-handler!)
  (init-all-screens!)
  (load-user-config!)
  (setup-bindings!)
  (pickup-windows!))

(define (main . args)
  (dynamic-wind
    (lambda ()
      (current-display (x-open-display #f))
      (if (not (current-display))
          (error "Unable to open display"))
      (init!))
    (lambda ()
      (x-sync (current-display) #f)
      (main-loop))
    (lambda ()
      (shutdown-hook)
      (set! *screens* (vector))
      (current-display #f)
      (##gc))))
