(define *bar-font* "-*-fixed-medium-r-*-*-14-*-*-*-*-*-iso10646-1")
(define *bar-norm-bg-color* "black")
(define *bar-norm-color* "gray")
(define *bar-sel-bg-color* "#403010")
(define *bar-sel-color* "white")

(define (make-dmenu-command title)
  (let ((args `("-p" ,title
                "-fn" ,*bar-font*
                "-nb" ,*bar-norm-bg-color*
                "-nf" ,*bar-norm-color*
                "-sb" ,*bar-sel-bg-color*
                "-sf" ,*bar-sel-color*)))
    (with-output-to-string '()
      (lambda ()
        (display "dmenu")
        (for-each (lambda (a) (display (list " \"" a "\""))) args)))))

(define (dmenu title fn)
  (let ((args `("-p" ,title
                "-fn" ,*bar-font*
                "-nb" ,*bar-norm-bg-color*
                "-nf" ,*bar-norm-color*
                "-sb" ,*bar-sel-bg-color*
                "-sf" ,*bar-sel-color*)))
    (with-exception-catcher
      (lambda (e) #f)
      (lambda ()
        (let ((p #f))
          (dynamic-wind
            (lambda () (set! p (open-process `(path: "dmenu"
                                               arguments: ,args))))
            (lambda ()
              (if p 
                  (begin (for-each
                           (lambda (line)
                             (display line p)
                             (newline p))
                           (fn))
                         (force-output p)
                         (close-output-port p)
                         (let ((ret (read-line p)))
                           (if (eof-object? ret)
                               #f
                               ret)))))
            (lambda () (if p (close-port p)))))))))

(define (run-command cmd)
  (if cmd
      (let ((t (make-thread (lambda () (shell-command cmd)))))
        (cond (t (thread-start! t)
                 t)
              (else #f)))))

(define (status fn args)
  (with-exception-catcher
    (lambda (e) #f)
    (lambda ()
      (let ((p #f))
        (dynamic-wind
          (lambda () (set! p (open-process `(path: "dzen2"
                                             arguments: ,args))))
          (lambda () 
            (if p
                (let loop ()
                  (let ((line (fn)))
                    (if line 
                        (begin
                          (display line p)
                          (newline p)
                          (force-output p)
                          (loop)))))))
          (lambda () (if p (close-port p))))))))

(define (bar side)
  (let* ((align (case side 
                  ((left) "l")
                  ((right) "r")
                  ((center) "c")))
         (t (make-thread 
              (lambda ()
                (status (lambda () (thread-receive)) 
                        `("-ta" ,align 
                          "-fn" ,*bar-font*))))))
    (thread-start! t)
    t))

