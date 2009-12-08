(define (setup-window-bindings disp win)
  (x-ungrab-key disp +any-key+ +any-modifier+ win)
  (for-each
    (lambda (key)
      (let ((code (x-keysym-to-keycode disp (car key))))
        (if (and code (not (zero? (char->integer code))))
            (for-each
              (lambda (mod)
                (x-grab-key disp
                            (char->integer code)
                            (bitwise-ior (cdr key) mod)
                            win
                            #t
                            +grab-mode-async+
                            +grab-mode-async+))
              (cons 0 *ignored-modifiers*)))))
    (map car (cdr *top-map*))))

(define (setup-bindings disp)
  (for-each
    (lambda (s) (setup-window-bindings disp (screen-root s)))
    *screens*))

;; Here we should catch all other events and process them
(define (read-x11-key disp)
  (let ((ev (x-check-mask-event disp +key-press-mask+)))
    (if ev
        ((lambda/x-event key-press (display keycode state)
                         (cons (x-keycode-to-keysym display
                                                    (integer->char keycode)
                                                    0)
                               state))
         ev)
        (read-x11-key disp))))

(define-macro (with-keyboard-grabbed args . body)
  (let ((dpy (gensym))
        (win (gensym))
        (mode '+grab-mode-async+))
    `(let ((,dpy ,(car args))
           (,win ,(cadr args)))
       (dynamic-wind
         (lambda ()
           (x-grab-keyboard ,dpy ,win #t ,mode ,mode +current-time+)
           (let loop ()
             (if (x-check-mask-event ,dpy +focus-change-mask+)
                 (loop))))
         (lambda () ,@body)
         (lambda ()
           (x-ungrab-keyboard ,dpy +current-time+)
           (x-sync ,dpy #f))))))

(define (process-key-sequence disp keymap)
  (let* ((key (read-x11-key disp))
         (binding (find-bindings (car key) (cdr key) keymap)))
    (cond ((or (null? binding) (not (pair? binding))) #f)
          ((procedure? (cdr binding)) ((cdr binding)))
          ((pair? (cdr binding))
           (process-key-sequence disp (cdr binding))))))

(define (process-keypress disp key mod keymap)
  (let ((binding (find-bindings key mod keymap)))
    (cond ((or (null? binding) (not (pair? binding))) #f)
          ((procedure? (cdr binding)) ((cdr binding)))
          ((pair? (cdr binding))
           (with-keyboard-grabbed (disp (screen-root (current-screen)))
             (process-key-sequence disp (cdr binding)))))))

(define (handle-keypress-event disp key state)
  (process-keypress disp key (clean-mod state) (cdr *top-map*)))
