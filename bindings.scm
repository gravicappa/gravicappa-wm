(define (setup-window-bindings display win)
  (x-ungrab-key display +any-key+ +any-modifier+ win)
  (for-each
    (lambda (key)
      (let ((code (x-keysym-to-keycode display (car key))))
        (when (and code (not (zero? (char->integer code))))
          (for-each
            (lambda (mod)
              (x-grab-key display
                          (char->integer code)
                          (bitwise-ior (cdr key) mod)
                          win
                          #t
                          +grab-mode-async+
                          +grab-mode-async+))
            (cons 0 *ignored-modifiers*)))))
    (map car *top-map*)))

(define (setup-bindings display)
  (for-each
    (lambda (s)
      (setup-window-bindings display (screen-root s)))
    *screens*))

;; Here we should catch all other events and process them
(define (read-x11-key display)
  (let ((ev (x-check-mask-event display +key-press-mask+)))
    (if ev
        ((lambda/x-event key-press (display keycode state)
                         (cons (x-keycode-to-keysym display 
                                                    (integer->char keycode) 
                                                    0) 
                               state))
         ev)
        (read-x11-key display))))

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

(define (process-key-sequence display keymap)
  (let* ((key (read-x11-key display))
         (binding (find-bindings (car key) (cdr key) keymap)))
    (cond ((or (null? binding) (not (pair? binding))) #f)
          ((procedure? (cdr binding)) ((cdr binding)))
          ((pair? (cdr binding))
           (process-key-sequence display (cdr binding))))))

(define (process-keypress display key mod keymap)
  (let ((binding (find-bindings key mod keymap)))
    (cond ((or (null? binding) (not (pair? binding))) #f)
          ((procedure? (cdr binding)) ((cdr binding)))
          ((pair? (cdr binding))
           (with-keyboard-grabbed (display (screen-root (current-screen)))
             (process-key-sequence display (cdr binding)))))))

(define (handle-keypress-event display key state)
  (process-keypress display key (clean-mod state) *top-map*))

(set! *keypress-hook* '(handle-keypress-event))
