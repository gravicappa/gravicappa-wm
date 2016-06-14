(define x11-event-handlers (make-table))

(define debug-events? #f)
(define debug-loglevel 1)

(define (display-log level . args)
  (if (<= level debug-loglevel)
      (let ((port (current-error-port)))
        (display ";; " port)
        (for-each (lambda (a) (display a port)) args)
        (newline port)
        (force-output port))))

(define (find-in-vector test v)
  (let loop ((i 0))
    (if (< i (vector-length v))
        (if (test (vector-ref v i))
            (vector-ref v i)
            (loop (+ i 1)))
        #f)))

(define (set-xevent-handler! ev proc) (table-set! x11-event-handlers ev proc))

(define-macro (eval-at-macroexpand expr)
  (eval expr)
  expr)

(eval-at-macroexpand
  (define (find item <list>)
    (let ((found (member item <list>)))
      (if found
          (car found)
          #f))))

(eval-at-macroexpand
  (define (complement fn) (lambda args (not (apply fn args)))))

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
                   (enter-notify . x-crossing-event)
                   (client-message . x-client-message-event)))))

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
    5
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
         (if debug-events?
             (log-x-event ',event ,ev))
         ,@body))))

(define-macro (define-x-event-handler args . body)
  `(set-xevent-handler!
    ,(string->symbol (string-append "x#+" (symbol->string (car args)) "+"))
    (lambda/x-event ,(car args) ,(cdr args) ,@body)))

(define (last lst)
  (if (pair? lst)
      (if (pair? (cdr lst))
          (last (cdr lst))
          (car lst))
      #f))

(define (flag-set? flags mask) (= (bitwise-and flags mask) mask))
