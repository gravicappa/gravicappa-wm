(define (read-chars prefix block? port)
  (let loop ((acc prefix))
    (if (or block? (char-ready? port))
        (let ((c (read-char port)))
          (if (eof-object? c)
              acc
              (loop (string-append acc (string c)))))
        acc)))

(define (pipe-command cmd lines)
  (with-exception-handler
    (lambda (e) "")
    (lambda ()
      (let ((p (open-process (list 'path: (car cmd) 'arguments: (cdr cmd))))
            (s ""))
        (dynamic-wind
          (lambda () #f)
          (lambda ()
            (if p
                (begin
                  (for-each (lambda (line)
                              (display line p)
                              (newline p)
                              (set! s (read-chars s #f p)))
                            lines)
                  (force-output p)
                  (close-output-port p)
                  (read-chars s #t p))))
          (lambda () (if p (close-port p))))))))
