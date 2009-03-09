(define *x11-event-dispatcher* (make-table))

(define +debug-events+ #t)

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

(define (find item <list>)
  (if (pair? <list>)
      (if (eq? (car <list>) item)
          item
          (find item (cdr <list>)))
      #f))

(define (add-to-list <list> item)
  (if (not (find item <list>))
      (set-cdr! <list> (append <list> (list item)))))

(define-macro (push item <list>)
  `(set! <list> (cons ,item <list>)))

(define-macro (define-hook name)
  `(define ,name (list (lambda args #f))))

(define (run-hook hook . args)
  (for-each (lambda (hook) 
              (apply (cond ((procedure? hook) hook)
                           ((symbol? hook) (eval hook)))
                     args))
            hook))

(define (add-hook hook fn)
  (set-cdr! hook (append (cdr hook) (list fn))))

(eval-when-load 
  (define (complement fn)
    (lambda args (not (apply fn args)))))

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

(eval-when-load
  (define (remove-if fn <list>)
    (filter (complement fn) <list>)))

(define (remove item <list>)
  (remove-if (lambda (i) (eq? i item)) <list>))

(eval-when-load
  (define event-struct-mapping 
    (list->table '((mapping-notify . x-mapping-event)
                   (destroy-notify . x-destroy-window-event)
                   (unmap-notify . x-unmap-event)
                   (property-notify . x-property-event)
                   (configure-notify . x-configure-event)
                   (focus-in . x-focus-change-event)
                   (button-press . x-button-pressed-event)
                   (key-press . x-key-event)
                   (enter-notify . x-crossing-event)))))

(eval-when-load
  (define (struct-from-event event)
    (let ((ev (table-ref event-struct-mapping event #f)))
      (if ev
          ev
          (string->symbol (string-append "x-"
                                         (symbol->string event)
                                         "-event"))))))

(eval-when-load
  (define (make-event-symbol type slot)
    (string->symbol (string-append (symbol->string type)
                                   "-"
                                   (symbol->string slot)))))

(define-macro (x-event-lambda event args . body)
  (let ((slots (remove-if (lambda (slot) (eq? slot 'ev)) args))
        (x-event (struct-from-event event))
        (ev (gensym)))
    `(lambda (,ev)
       (let (,@(map (lambda (i) `(,i (,(make-event-symbol x-event i) ,ev)))
                    slots)
             ,@(if (find 'ev args)
                   `((ev ,ev))
                   '()))
         (when +debug-events+
           (display-log "[x11] event (id: " ',x-event ")\n" 
                        "               (serial: " (x-any-event-serial ,ev) ")\n"
                        "               (num: " 
                        ,(string->symbol 
                           (string-append "+" 
                                          (symbol->string event) 
                                          "+"))
                        ")\n"
                        "               (win: " (x-any-event-window ,ev) ")\n"
                        "\n"))
         ,@body))))

(define-macro (define-x-event args . body)
  `(table-set! *x11-event-dispatcher*
               ,(string->symbol 
                  (string-append "+" (symbol->string (car args)) "+"))
               (x-event-lambda ,(car args) ,(cdr args) ,@body)))

(define (get-colour display screen color)
  (let* ((cmap (x-default-colormap-of-screen 
                 (x-screen-of-display display (screen-id screen))))
         (c (make-x-color-box))
         (component (lambda (mask shift) 
                      (arithmetic-shift (bitwise-and color mask) shift)))
         (ret (cond 
                ((string? color)
                 (= (x-parse-color display cmap color c) 1))
                ((number? color)
                 (x-color-red-set! c (component #xff0000 -8))
                 (x-color-green-set! c (component #x00ff00 0))
                 (x-color-blue-set! c (component #x0000ff 8))
                 #t))))
    (when (and ret (= (x-alloc-color display cmap c) 1))
      (x-color-pixel c))))

(define-macro (destructuring-bind args expr . body)
  `(apply (lambda ,args ,@body) ,expr))
