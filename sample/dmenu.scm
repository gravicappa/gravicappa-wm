(define (dmenu title lines)
  (string-trim-right
   (pipe-command (list "dmenu" "-p" title) lines)
   #\newline))
