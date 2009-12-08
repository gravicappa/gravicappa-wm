(define-macro (eval-at-macro-expansion expr)
  (eval expr)
  `(begin))

(eval-at-macro-expansion
 (define (make-structure-definition name slot-defs)
   (let* ((ensure-string (lambda (s) (if (string? s) s (symbol->string s))))
          (symbol-append
            (lambda a
              (string->symbol (apply string-append (map ensure-string a)))))
          (constr (symbol-append "make-" name "*"))
          (pred (symbol-append name "?"))
          (slot-name (lambda (def) (if (pair? def) (car def) def)))
          (slot-init (lambda (def) (if (pair? def) (cadr def) #f))))
     `(begin
       (define-record-type ,name
         (,constr ,@(map slot-name slot-defs))
         ,pred
         ,@(map (lambda (def)
                  (let ((slot (slot-name def)))
                    (list slot
                          (symbol-append name "-" slot)
                          (symbol-append "set-" name "-" slot "!"))))
                slot-defs))
       (define (,(symbol-append "make-" name) . params)
         (let ((val (lambda (key default)
                      (let ((c (member key params)))
                        (if (pair? c)
                            (cadr c)
                            (default))))))
           (,constr
            ,@(map (lambda (def)
                     (let ((slot (string->keyword
                                  (symbol->string (slot-name def))))
                           (init (slot-init def)))
                       `(val ,slot (lambda () ,init))))
                   slot-defs))))))))

(define-macro (define-structure* name . slot-defs)
  (make-structure-definition name slot-defs))
