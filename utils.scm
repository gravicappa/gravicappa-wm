(define *x11-event-dispatcher* (make-table))

(define +debug-events+ #t)

(define (display-log . args)
  (let ((port (current-error-port)))
    (display ";; " port)
    (for-each (lambda (a) (display a port)) args)
    (newline port)))

(define-macro (eval-at-macroexpand expr)
  (eval expr)
  expr)

(define-macro (when expr . body)
  `(if ,expr
       (begin ,@body)
       #f))

(define-macro (unless expr . body)
  `(if ,expr
       #f
       (begin ,@body)))

(eval-at-macroexpand
  (define (find item <list>)
    (let ((found (member item <list>)))
      (if found
          (car found)
          #f))))

(define (add-to-list <list> item)
  (if (not (find item <list>))
      (set-cdr! <list> (append <list> (list item)))))

(define-macro (define-hook name)
  `(define ,name (list (lambda args #f))))

(define (run-single-hook fn args)
  (apply (cond ((procedure? fn) fn)
               ((or (symbol? fn) (pair? fn)) (eval fn)))
         args))

(define (chain hook . args)
  (let loop ((hook hook))
    (if (and (pair? hook) (not (run-single-hook (car hook))))
        (loop (cdr hook)))))

(define (run-hook hook . args)
  (for-each (lambda (h) (run-single-hook h args))
            hook))

(define (add-hook hook fn)
  (set-cdr! hook (append (cdr hook) (list fn))))

(eval-at-macroexpand
  (define (complement fn)
    (lambda args (not (apply fn args)))))

(eval-at-macroexpand
  (define (filter fn <list>)
    (let loop ((<list> <list>)
               (acc '()))
      (if (pair? <list>)
          (loop (cdr <list>) (if (fn (car <list>))
                                 (cons (car <list>) acc)
                                 acc))
          (reverse acc)))))

(eval-at-macroexpand
  (define (find-if fn <list>)
    (if (pair? <list>)
        (if (fn (car <list>))
            (car <list>)
            (find-if fn (cdr <list>)))
        #f)))

(eval-at-macroexpand
  (define (remove-if fn <list>)
    (filter (complement fn) <list>)))

(define (remove item <list>)
  (remove-if (lambda (i) (eq? i item)) <list>))

(eval-at-macroexpand
  (define event-struct-mapping
    (list->table '((mapping-notify . x-mapping-event)
                   (destroy-notify . x-destroy-window-event)
                   (unmap-notify . x-unmap-event)
                   (map-notify . x-map-event)
                   (property-notify . x-property-event)
                   (configure-notify . x-configure-event)
                   (focus-in . x-focus-change-event)
                   (button-press . x-button-event)
                   (key-press . x-key-event)
                   (enter-notify . x-crossing-event)))))

(eval-at-macroexpand
  (define (struct-from-event event)
    (let ((ev (table-ref event-struct-mapping event #f))
          (ev-str (symbol->string event)))
      (if ev
          ev
          (string->symbol (string-append "x-" ev-str "-event"))))))

(eval-at-macroexpand
  (define (make-event-symbol type slot)
    (string->symbol (string-append (symbol->string type)
                                   "-"
                                   (symbol->string slot)))))

(define (log-x-event name ev)
  (display-log
    "\n"
    "[x11] event (name: " name ")\n"
    "            (send-event?: " (x-any-event-send-event? ev) ")\n"
    "            (win: " (x-any-event-window ev) ")\n"))

(define-macro (lambda/x-event event args . body)
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
           (log-x-event ',event ,ev))
         ,@body))))

(define-macro (define-x-event-handler args . body)
  `(table-set! *x11-event-dispatcher*
               ,(string->symbol
                  (string-append "+" (symbol->string (car args)) "+"))
               (lambda/x-event ,(car args) ,(cdr args) ,@body)))

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
