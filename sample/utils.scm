(define (eval-from-string str)
  (if (string? str)
      (with-exception-handler
        (lambda (e) #f)
        (lambda () (eval (with-input-from-string str read))))))

(define (split-string sep s)
  (let ((len (string-length s)))
    (let loop ((start 0)
               (i 0)
               (acc '()))
      (if (< i len)
          (if (char=? (string-ref s i) sep)
              (loop (+ i 1) (+ i 1) (if (< start i)
                                        (cons (substring s start i) acc)
                                        acc))
              (loop start (+ i 1) acc))
          (if (< start i)
              (reverse (cons (substring s start len) acc))
              (reverse acc))))))

(define (write-to-file-or-fail string filename)
  (with-exception-catcher
    (lambda (e) #f)
    (lambda ()
      (if (file-exists? filename)
          (with-output-to-file
            filename
            (lambda ()
              (display string)
              (newline))))
      #t)))

(define (write-to-pipe str filename)
  (if (not (write-to-file-or-fail str filename))
      (begin
        (thread-sleep! 1/100)
        (write-to-file-or-fail str filename))))
