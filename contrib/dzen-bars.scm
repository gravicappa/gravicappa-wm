
(define left-bar #f)
(define right-bar #f)

(define (dzen-args args)
  (append (list "-bg" *bar-norm-bg-color*
                "-fg" *bar-norm-color*
                "-fn" *bar-font*)
          args))

(define (bar fn args)
  (with-exception-catcher
    (lambda (e) #f)
    (lambda ()
      (let ((p (open-process `(path: "dzen2" arguments: ,(dzen-args args)))))
        (dynamic-wind
          (lambda () #f)
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

(define (tag-bar align x width)
  (let ((t (make-thread
             (lambda ()
               (bar thread-receive
                    (list "-x" (number->string x)
                          "-ta" align
                          "-tw" (number->string width)))))))
    (thread-start! t)
    t))

(define (restart-bars)
  (let ((w/2 (inexact->exact (round (/ (screen-w (current-screen)) 2)))))
    (shell-command "killall dzen2")
    (shell-command "killall status")
    (set! left-bar (tag-bar "l" 0 w/2))
    (set! right-bar (tag-bar "r" w/2 w/2))
    (status-process right-bar)))
