
(define *x11-event-dispatcher* (make-table))

(define (run-hook hooks . args)
  (let loop ((hooks hooks))
    (cond ((pair? hooks)
           (apply (car hooks) args)
           (loop (cdr hooks))))))

(define (find item <list>)
  (if (pair? <list>)
      (if (eq? (car <list>) item)
          item
          (find item (cdr <list>)))
      #f))

(define-macro (add-to-list <list> item)
  `(if (not (find ,item ,<list>))
       (set! ,<list> (append ,<list> (list ,item)))))

(define-macro (define-hook name)
  `(define ,name '()))

(define-macro (define-x11-event-handler event slots . body)
  `(table-set! *x11-event-dispatcher* event
     (lambda (ev)
       (let ()
         ,@body))))
