(define *dmenu* "dmenu")

(define (dmenu title thunk)
  (with-exception-handler
    (lambda (e) #f)
    (lambda ()
      (let ((p (open-process `(path: "dmenu" arguments: ("-p" ,title)))))
        (dynamic-wind
          (lambda () #f)
          (lambda ()
            (if p
                (begin
                  (for-each (lambda (line)
                              (display line p)
                              (newline p))
                            (thunk))
                  (force-output p)
                  (close-output-port p)
                  (let ((ret (read-line p)))
                    (if (eof-object? ret)
                        #f
                        ret)))))
          (lambda () (if p (close-port p))))))))
