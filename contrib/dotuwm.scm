(include "~/develop/run.scm")

(define *border-color* #x070707)
(define *selected-border-color* #xfdaf3e)
(define *border-width* 1)
(define *bar-height* 16)
(define *tile-ratio* 55/100)

(define *dmenu-runner*
  (string-append "`" (make-dmenu-command "Run:") "< ~/.programs`"))

(define left-bar #f)
(define right-bar #f)

(define (restart-bars)
  (run-command "killall dzen2")
  (set! left-bar (bar 'left))
  (set! right-bar
    (run-command
      "status | dzen2 -ta r -tw 500 -x 1180 -fn -*-fixed-medium-r-*-*-14-*-*-*-*-*-iso10646-1")))

(define (update-tag-status)
  (let ((tags (collect-all-tags)))
    (if left-bar
        (thread-send
          left-bar
          (with-output-to-string '()
            (lambda ()
              (display (list *current-view* " |"))
              (for-each (lambda (t)
                          (display " ")
                          (if (string=? t *current-view*)
                              (display (list "[" t "]"))
                              (display t)))
                        tags)))))))

(update-tag-status)

(add-hook *retag-hook* 'update-tag-status)

(define (to-run fn)
  (if fn
      (thread-send (current-thread) fn)))

(define (make-splitter sep)
  (lambda (str)
    (call-with-input-string
      str
      (lambda (p)
        (read-all p (lambda (p) (read-line p sep)))))))

(define (make-splitter sep)
  (lambda (str)
    (call-with-input-string
      str
      (lambda (p)
        (read-all p (lambda (p) (read-line p sep)))))))

(define parse-tags
  (let ((split (make-splitter #\,)))
    (lambda (str)
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
              (values +tags -tags)))))))

(define (tag c)
  (if c
      (call-with-values
        (lambda ()
          (parse-tags (dmenu "Tag client:" (lambda () (collect-all-tags)))))
        (lambda (+tags -tags)
          (to-run (lambda ()
                    (tag-client c +tags)
                    (untag-client c -tags)))))))

(define *prev-view* "")

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
         (untag-client *selected* ".")
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

(define-key *top-map* (kbd "s-x s-c") (lambda () (exit)))
(define-key *top-map* (kbd "s-x s-l")
            (lambda ()
              (run-command "killall dzen2")
              (load *user-config-file*)))
(define-key *top-map* (kbd "s-RET") (lambda () (run-command "xterm")))
(define-key *top-map* (kbd "s-p") (lambda () (run-command *dmenu-runner*)))
(define-key *top-map* (kbd "s-c") (lambda () (kill-client *selected*)))
(define-key *top-map* (kbd "s-h") (lambda () (focus-client 'left)))
(define-key *top-map* (kbd "s-j") (lambda () (focus-client 'down)))
(define-key *top-map* (kbd "s-k") (lambda () (focus-client 'up)))
(define-key *top-map* (kbd "s-l") (lambda () (focus-client 'right)))
(define-key *top-map* (kbd "s-a") (lambda () (focus-previous)))
(define-key *top-map* (kbd "s-o") (lambda () (zoom-client)))
(define-key *top-map* (kbd "s-TAB") (lambda () (focus-in-list 'after)))
(define-key *top-map* (kbd "s-S-TAB") (lambda () (focus-in-list 'before)))

(define-key *top-map* (kbd "s-f") (lambda () (toggle-fullscreen)))
(define-key *top-map* (kbd "s-m") (lambda () (tag *selected*)))
(define-key *top-map* (kbd "s-t") (lambda () (view)))
(define-key *top-map* (kbd "s-r") (lambda () (view-tag *prev-view*)))

(define-key *top-map* (kbd "s-e")
            (lambda () (to-run (lambda ()
                                 (eval-from-string
                                   (dmenu "Eval:" (lambda () '())))))))


(define-key *top-map* (kbd "s-M-h")
            (lambda () (resize-client-by *selected* 0 0 -50 0)))
(define-key *top-map* (kbd "s-M-j")
            (lambda () (resize-client-by *selected* 0 0 0 50)))
(define-key *top-map* (kbd "s-M-k")
            (lambda () (resize-client-by *selected* 0 0 0 -50)))
(define-key *top-map* (kbd "s-M-l")
            (lambda () (resize-client-by *selected* 0 0 50 0)))

(define-key *top-map* (kbd "s-S-h")
            (lambda () (resize-client-by *selected* -50 0 0 0)))
(define-key *top-map* (kbd "s-S-j")
            (lambda () (resize-client-by *selected* 0 50 0 0)))
(define-key *top-map* (kbd "s-S-k")
            (lambda () (resize-client-by *selected* 0 -50 0 0)))
(define-key *top-map* (kbd "s-S-l")
            (lambda () (resize-client-by *selected* 50 0 0 0)))

(restart-bars)
