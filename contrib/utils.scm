(define *bar-font* "-*-fixed-medium-r-*-*-14-*-*-*-*-*-iso10646-1")
(define *bar-norm-bg-color* "black")
(define *bar-norm-color* "gray")
(define *bar-sel-bg-color* "#440000")
(define *bar-sel-color* "white")

(define *prev-view* "")

(define (to-run fn)
  (if fn
      (thread-send (current-thread) fn)))

(define (shell-command& cmd)
  (if (string? cmd)
      (thread-start!
       (make-thread (lambda () (shell-command (string-append cmd "&")))))))

(define (status-process bar)
  (thread-start!
    (make-thread
      (lambda ()
        (let ((p (open-process "status")))
          (let loop ()
            (let ((line (read-line p)))
              (if (eof-object? line)
                  #f
                  (begin
                    (thread-send bar line)
                    (loop))))))))))

(define (display-current-view tag)
  (display (string-append "[" tag "]")))

(define (display-previous-view tag)
  (display (string-append "(" tag ")")))

(define (update-tag-status)
  (let ((tags (collect-all-tags)))
    (if left-bar
        (thread-send
          left-bar
          (with-output-to-string '()
            (lambda ()
              (display (string-append *current-view* " | " *prev-view*))
              (for-each (lambda (t)
                          (if (not (or (string=? t *current-view*)
                                       (string=? t *prev-view*)))
                              (display (string-append " " t))))
                        tags)))))))

(define (make-splitter sep)
  (lambda (str)
    (call-with-input-string
      str
      (lambda (p)
        (read-all p (lambda (p) (read-line p sep)))))))

(define parse-tags
  (let ((split (make-splitter #\,)))
    (lambda (str)
      (if (string? str)
          (split str)
          '()))))

(define (update-client-tags c)
  (if c
      (begin
        (run-hook *retag-hook*)
        (run-hook *arrange-hook* (client-display c) (client-screen c)))))

(define (tag c)
  (if c
      (let ((all-tags (collect-all-tags)))
        (for-each
          (lambda (t) (tag-client c t))
          (parse-tags (dmenu "Tag client:" (lambda () all-tags))))
        (update-client-tags c))))

(define (untag c)
  (if c
      (begin
        (for-each
          (lambda (t) (untag-client c t))
          (parse-tags (dmenu "Untag client:" (lambda () (client-tags c)))))
        (update-client-tags c))))

(define (move-tag c)
  (if c
      (let ((all-tags (collect-all-tags))
            (prev-tags (client-tags c)))
        (for-each
          (lambda (t) (tag-client c t))
          (parse-tags (dmenu "Move client:" (lambda () all-tags))))
        (for-each (lambda (t) (untag-client c t)) prev-tags)
        (update-client-tags c))))

(define (view-tag tag)
  (if (string? tag)
      (begin
        (if (not (string=? *current-view* tag))
            (set! *prev-view* *current-view*))
        (to-run (lambda () (view-clients tag))))))

(define (toggle-fullscreen)
  (if *selected*
      (cond
        ((string=? *current-view* ".")
         (untag-client *selected* ".")
         (view-tag *prev-view*))
        (else
          (mass-untag-clients ".")
          (tag-client *selected* ".")
          (view-tag ".")))))

(define (eval-from-string str)
  (if (string? str)
      (with-exception-catcher
        (lambda (e) #f)
        (lambda ()
          (eval (with-input-from-string str (lambda () (read))))))))
