(define *prev-view* "")
(define *tags-fifo* (string-append "~/tmp/tags" (getenv "DISPLAY")))

(define (to-run fn)
  (if fn
      (thread-send (current-thread) fn)))

(define (shell-command& cmd)
  (if (string? cmd)
      (thread-start!
        (make-thread (lambda () (shell-command (string-append cmd "&")))))))

(define (update-tag-status)
  (let ((tags (collect-all-tags)))
    (if (file-exists? *tags-fifo*)
        (with-output-to-file
          *tags-fifo*
          (lambda ()
            (display (string-append (current-view) " | " *prev-view*))
            (for-each (lambda (t)
                        (if (not (or (string=? t (current-view))
                                     (string=? t *prev-view*)))
                            (display (string-append " " t))))
                      tags)
            (newline))))))

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
         (untag-all-client (current-client) ".")
         (view-tag *prev-view*))
        (else
          (untag-all-clients ".")
          (tag-client (current-client) ".")
          (view-tag ".")))))

(define (eval-from-string str)
  (if (string? str)
      (with-exception-catcher
        (lambda (e) #f)
        (lambda ()
          (eval (with-input-from-string str (lambda () (read))))))))
