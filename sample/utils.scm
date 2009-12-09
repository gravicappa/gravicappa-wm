(define *prev-view* "")
(define *tags-fifo* (string-append "~/tmp/tags" (getenv "DISPLAY")))

(define (to-run thunk)
  (if (procedure? thunk)
      (thread-send (current-thread) thunk)))

(define (shell-command& cmd)
  (if (string? cmd)
      (thread-start!
        (make-thread (lambda () (shell-command (string-append cmd "&")))))))

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
             (str (string-append (current-view) " | " *prev-view*)))
    (if (pair? tags)
        (loop (cdr tags)
              (if (or (string=? (car tags) (current-view))
                      (string=? (car tags) *prev-view*))
                  str
                  (string-append str " " (car tags))))
        (if (not (write-to-file-or-fail str *tags-fifo*))
            (begin
              (thread-sleep! 1/100)
              (write-to-file-or-fail str *tags-fifo*))))))

(define (parse-tags str)
  (if (string? str)
      (split-string #\space str)
      '()))

(define (tag c)
  (if c
      (let ((all-tags (collect-all-tags)))
        (for-each
          (lambda (t) (tag-client c t))
          (parse-tags (dmenu "Tag client:" (lambda () all-tags)))))))

(define (untag c)
  (if c
      (begin
        (for-each
          (lambda (t) (untag-client c t))
          (parse-tags (dmenu "Untag client:" (lambda () (client-tags c))))))))

(define (view-tag tag)
  (if (string? tag)
      (begin
        (if (not (string=? (current-view) tag))
            (set! *prev-view* (current-view)))
        (to-run (lambda () (view-clients tag))))))

(define (toggle-fullscreen)
  (if (current-client)
      (cond
        ((string=? (current-view) ".")
         (untag-client (current-client) ".")
         (view-tag *prev-view*))
        (else
          (untag-all-clients ".")
          (tag-client (current-client) ".")
          (view-tag ".")))))

(define (eval-from-string str)
  (if (string? str)
      (with-exception-handler
        (lambda (e) #f)
        (lambda () (eval (with-input-from-string str read))))))
