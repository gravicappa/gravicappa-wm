(define *bar-font* "-*-fixed-medium-r-*-*-14-*-*-*-*-*-iso10646-1")
(define *bar-norm-bg-color* "black")
(define *bar-norm-color* "gray")
(define *bar-sel-bg-color* "#440000")
(define *bar-sel-color* "white")

(define *prev-view* "")

(define (to-run fn)
  (if fn
      (thread-send (current-thread) fn)))

(define (dmenu-args title)
  (list "-p" title
        "-fn" *bar-font*
        "-nb" *bar-norm-bg-color*
        "-nf" *bar-norm-color*
        "-sb" *bar-sel-bg-color*
        "-sf" *bar-sel-color*))

(define (dzen-args args)
  (append (list "-bg" *bar-norm-bg-color*
                "-fg" *bar-norm-color*
                "-fn" *bar-font*)
          args))

(define (make-dmenu-command title)
  (with-output-to-string '()
    (lambda ()
      (display "dmenu")
      (for-each (lambda (a) (display (string-append " \"" a "\"")))
                  (dmenu-args title)))))

(define (dmenu title fn)
  (with-exception-catcher
    (lambda (e) #f)
    (lambda ()
      (let ((p (open-process `(path: "dmenu"
                               arguments: ,(dmenu-args title)))))
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

(define (shell-command& cmd)
  (if (string? cmd)
      (thread-start!
       (make-thread (lambda () (shell-command (string-append cmd "&")))))))

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

(define left-bar #f)
(define right-bar #f)

(define (restart-bars)
  (let ((w/2 (inexact->exact (round (/ (screen-w (current-screen)) 2)))))
    (shell-command "killall dzen2")
    (shell-command "killall status")
    (set! left-bar (tag-bar "l" 0 w/2))
    (set! right-bar (tag-bar "r" w/2 w/2))
    (status-process right-bar)))

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
  (run-hook *retag-hook*)
  (run-hook *arrange-hook* (client-display c) (client-screen c)))

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

(define (view-tag tag)
  (if (string? tag)
      (begin
        (if (not (string=? *current-view* tag))
            (set! *prev-view* *current-view*))
        (to-run (lambda () (view-clients tag))))))

(define (view)
  (view-tag (dmenu "View:" (lambda () (collect-all-tags)))))

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
