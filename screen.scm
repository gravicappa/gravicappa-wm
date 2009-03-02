
(define-structure screen
  id
  x
  y
  w
  h
  root
  clients)

(define *screens* '())

(define (init-screens display)
  (let ((num (x-screen-count display)))
    (let loop ((i 0))
      (cond ((< i num)
             (init-single-screen display i)
             (loop (+ 1 i)))))))

(define (init-single-screen display i)
  (let* ((root (x-root-window display i))
         ((screen (make-screen i
                               0
                               0
                               (x-display-width display i)
                               (x-display-height display i)
                               root
                               '()))))
    ()
    (set *screens* (cons screen *screens*))))

(add-to-list *internal-startup-hook* (lambda (d) (init-screens d)))
