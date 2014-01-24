(define (showids)
  (let ((lst (filter client-visible? (clients-list (current-screen)))))
    (pipe-command '("xshowid")
                  (map (lambda (c) (number->string (client-window c))) lst))))
