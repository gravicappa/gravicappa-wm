(define prev-view (make-parameter ""))
(define *tags-fifo* (string-append "/tmp/gravicappa-wm.tags"
                                   (getenv "DISPLAY")))

(define (to-run thunk)
  (if (procedure? thunk)
      (thread-send (current-thread) thunk)))

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

(define (update-tag-status)
  (let loop ((tags (collect-all-tags))
             (str (string-append (current-view) " | " (prev-view))))
    (if (pair? tags)
        (loop (cdr tags)
              (if (or (string=? (car tags) (current-view))
                      (string=? (car tags) (prev-view)))
                  str
                  (string-append str " " (car tags))))
        (if (not (write-to-file-or-fail str *tags-fifo*))
            (begin
              (thread-sleep! 1/100)
              (write-to-file-or-fail str *tags-fifo*))))))

(define (parse-tags str)
  (if (and (string? str) (positive? (string-length str)))
      (split-string #\space str)
      '()))

(define (tag c)
  (if c
      (for-each
        (lambda (t) (tag-client c t))
        (parse-tags (dmenu "Tag client:" (collect-all-tags))))))

(define (untag c)
  (if c
      (begin
        (for-each
          (lambda (t) (untag-client c t))
          (parse-tags (dmenu "Untag client:" (lambda () (client-tags c))))))))

(define (view-tag tag)
  (if (and (string? tag) (positive? (string-length tag)))
      (begin
        (if (not (string=? (current-view) tag))
            (prev-view (current-view)))
        (to-run (lambda () (view-clients tag))))))

(define (toggle-fullscreen)
  (if (current-client)
      (cond
        ((string=? (current-view) ".")
         (untag-client (current-client) ".")
         (view-tag (prev-view)))
        (else
          (untag-all-clients ".")
          (tag-client (current-client) ".")
          (view-tag ".")))))

(define (eval-from-string str)
  (if (string? str)
      (with-exception-handler
        (lambda (e) #f)
        (lambda () (eval (with-input-from-string str read))))))

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
