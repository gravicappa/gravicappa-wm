(define *bar-font* "-*-fixed-medium-r-*-*-14-*-*-*-*-*-iso10646-1")
(define *bar-norm-bg-color* "black")
(define *bar-norm-color* "gray")
(define *bar-sel-bg-color* "#403010")
(define *bar-sel-color* "white")

(define *prev-view* "")

(define (to-run fn)
  (if fn
      (thread-send (current-thread) fn)))

(define (make-dmenu-command title)
  (let ((args `("-p" ,title
                "-fn" ,*bar-font*
                "-nb" ,*bar-norm-bg-color*
                "-nf" ,*bar-norm-color*
                "-sb" ,*bar-sel-bg-color*
                "-sf" ,*bar-sel-color*)))
    (with-output-to-string '()
      (lambda ()
        (display "dmenu")
        (for-each (lambda (a) (display (string-append " \"" a "\"")))
                  args)))))

(define (dmenu title fn)
  (let ((args `("-p" ,title
                "-fn" ,*bar-font*
                "-nb" ,*bar-norm-bg-color*
                "-nf" ,*bar-norm-color*
                "-sb" ,*bar-sel-bg-color*
                "-sf" ,*bar-sel-color*)))
    (with-exception-catcher
      (lambda (e) #f)
      (lambda ()
        (let ((p #f))
          (dynamic-wind
            (lambda () 
              (set! p (open-process `(path: "dmenu" arguments: ,args))))
            (lambda ()
              (if p
                  (begin (for-each
                           (lambda (line)
                             (display line p)
                             (newline p))
                           (fn))
                         (force-output p)
                         (close-output-port p)
                         (let ((ret (read-line p)))
                           (if (eof-object? ret)
                               #f
                               ret)))))
            (lambda () (if p (close-port p)))))))))

(define (shell-command& cmd)
  (if cmd
      (thread-start!
       (make-thread (lambda ()
                      (shell-command (string-append cmd "&")))))))

(define (status fn args)
  (with-exception-catcher
    (lambda (e) #f)
    (lambda ()
      (let ((p #f))
        (dynamic-wind
          (lambda () 
            (set! p (open-process `(path: "dzen2" arguments: ,args))))
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

(define (bar side width font)
  (let* ((align (case side
                  ((left) "l")
                  ((right) "r")
                  ((center) "c")))
         (t (make-thread
              (lambda ()
                (status (lambda () (thread-receive))
                        `("-ta" ,align
                          "-fn" ,font
                          "-tw" ,(number->string width)))))))
    (thread-start! t)
    t))

(define left-bar #f)
(define right-bar #f)

(define (restart-bars)
  (let ((w/2 (inexact->exact (round (/ (screen-w (current-screen)) 2)))))
    (shell-command "killall dzen2")
    (set! left-bar (bar 'left w/2 *bar-font*))
    (set! right-bar
          (shell-command& (string-append "status | dzen2 -ta r"
                                         " -tw " (number->string w/2)
                                         " -x " (number->string w/2)
                                         " -fn " *bar-font*)))))

(define (update-tag-status)
  (let ((tags (collect-all-tags)))
    (if left-bar
        (thread-send
          left-bar
          (with-output-to-string '()
            (lambda ()
              (display (string-append *current-view* " |"))
              (for-each (lambda (t)
                          (display " ")
                          (if (string=? t *current-view*)
                              (display (string-append "[" t "]"))
                              (display t)))
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
      (if str
          (let ((tags (split str)))
            (let loop ((tags tags)
                       (+tags '())
                       (-tags '()))
              (if (pair? tags)
                  (if (char=? #\- (string-ref (car tags) 0))
                      (loop (cdr tags)
                            +tags
                            (cons (substring (car tags)
                                             1
                                             (string-length (car tags)))
                                  -tags))
                      (loop (cdr tags) (cons (car tags) +tags) -tags))
                  (values +tags -tags))))
          (values '() '())))))

(define (tag c)
  (if c
      (call-with-values
        (lambda ()
          (parse-tags (dmenu "Tag client:" (lambda () (collect-all-tags)))))
        (lambda (+tags -tags)
          (to-run (lambda ()
                    (tag-client c +tags)
                    (untag-client c -tags)))))))

(define (view-tag tag)
  (if tag
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
         (untag-client *selected* '("."))
         (view-tag *prev-view*))
        (else
          (mass-untag-clients ".")
          (tag-client *selected* (cons "." (client-tags *selected*)))
          (view-tag ".")))))

(define (eval-from-string str)
  (if str
      (with-exception-catcher
        (lambda (e) #f)
        (lambda ()
          (eval (with-input-from-string str (lambda () (read))))))))
