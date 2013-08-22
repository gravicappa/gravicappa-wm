(define (dmenu title lines)
  (string-trim-right
    (pipe-command (append (split-string #\space (getenv "DMENU"))
                                        (list "-p" title))
                          lines)
                  #\newline))
