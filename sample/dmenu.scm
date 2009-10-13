(define (string<-args args . q)
  (let ((q (if (pair? q) (car q) "")))
    (let loop ((args args)
               (acc '()))
      (if (pair? args)
          (loop (cdr args) (append (if (pair? (cdr args))
                                       (list " " q (car args) q)
                                       (list q (car args) q))
                                   acc))
          (apply string-append (reverse acc))))))

(define (dmenu-args)
  (list "-fn" *bar-font*
        "-nb" *bar-norm-bg-color*
        "-nf" *bar-norm-color*
        "-sb" *bar-sel-bg-color*
        "-sf" *bar-sel-color*))

(define (dmenu title fn)
  (with-exception-catcher
    (lambda (e) #f)
    (lambda ()
      (let ((p (open-process `(path: "dmenu"
                               arguments: ("-p" ,title ,@(dmenu-args))))))
        (dynamic-wind
          (lambda () #f)
          (lambda ()
            (if p
                (begin
                  (for-each (lambda (line)
                              (display line p)
                              (newline p))
                            (fn))
                  (force-output p)
                  (close-output-port p)
                  (let ((ret (read-line p)))
                    (if (eof-object? ret)
                        #f
                        ret)))))
          (lambda () (if p (close-port p))))))))

(define (dmenu-run)
  (shell-command&
    (string-append "`dmenu -p 'Run:' "
                   (string<-args (dmenu-args) "'")
                   " < ~/.programs`")))
