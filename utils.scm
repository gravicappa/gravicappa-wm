(define *x11-event-dispatcher* (make-table))

(define (display-log . args)
  (display (cons ";; " args) (current-error-port))
  (newline (current-error-port)))

(define-macro (eval-when-load expr)
  (eval expr)
  `(begin))

(define-macro (when expr . body)
  `(if ,expr
       (begin ,@body)
       #f))

(define-macro (unless expr . body)
  `(if ,expr
       #f
       (begin ,@body)))

(define (run-hook hooks . args)
  (let loop ((hooks hooks))
    (cond ((pair? hooks)
           (let ((fn (car hooks)))
             (apply (cond ((procedure? fn) fn)
                          ((symbol? fn) (eval fn)))
                    args))
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

(define-macro (push item <list>)
  `(set! <list> (cons ,item <list>)))

(define-macro (define-hook name)
  `(define ,name '()))

(eval-when-load 
  (define %any-events '(type display serial send-event window)))

(define (complement fn)
  (lambda args (not (apply fn args))))

(eval-when-load
  (define (filter fn <list>)
    (let loop ((<list> <list>)
               (acc '()))
      (if (pair? <list>)
          (loop (cdr <list>) (if (fn (car <list>))
                                 (cons (car <list>) acc)
                                 acc))
          (reverse acc)))))

(eval-when-load
  (define (find-if fn <list>)
    (if (pair? <list>)
        (if (fn (car <list>))
            (car <list>)
            (find-if fn (cdr <list>)))
        #f)))

(eval-when-load
  (define (find item <list>)
    (find-if (lambda (i) (eq? i item)) <list>)))

(define (remove-if fn <list>)
  (filter (complement fn) <list>))

(eval-when-load
  (define (make-event-symbol type slot)
    (string->symbol (string-append (symbol->string type) 
                                   "-event-" 
                                   (symbol->string slot)))))

(define-macro (x-event-lambda event args . body)
  (let ((any-slots (filter (lambda (slot) (find slot %any-events))
                           args))
        (slots (filter (lambda (slot) (not (or (find slot %any-events)
                                               (eq? slot 'ev))))
                       args))
        (x-event (string->symbol (string-append "x-" (symbol->string event))))
        (ev (gensym)))
    `(lambda (,ev)
       (let (,@(map (lambda (i)
                      `(,i (,(make-event-symbol 'x-any i) ,ev)))
                    any-slots)
              ,@(map (lambda (i)
                       `(,i (,(make-event-symbol x-event i) ,ev)))
                     slots)
              ,@(if (find 'ev args)
                    `(ev ,ev)
                    '()))
         ,@body))))

(define-macro (define-x-event event args . body)
  `(table-set! *x11-event-dispatcher*
               ,event
               (x-event-lambda ,event ,args ,@body)))

