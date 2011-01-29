(define-macro (eval-at-macroexpand . expr)
  (eval `(begin ,@expr) (scheme-report-environment 5))
  (begin #f))

(eval-at-macroexpand (define ffi-releasers (make-table)))

(define-macro (extern-object-releaser-set! name code)
  (eval `(table-set! ffi-releasers ,name ,code)
        (scheme-report-environment 5))
  #f)

(extern-object-releaser-set! "release-rc" "___EXT(___release_rc)(p);\n")

(eval-at-macroexpand
  (define (string-replace new old str)
    (list->string (map (lambda (c)
                         (if (char=? c old)
                             new
                             c))
                       (string->list str)))))

(define (ffi#provided-mask v shift)
  (if (eq? v '())
      0
      (arithmetic-shift 1 shift)))

(define (ffi#provided-value v default)
  (if (eq? v '())
      default
      v))

(eval-at-macroexpand
  (define (make-provided-mask args)
    (let loop ((args args)
               (idx 0)
               (acc '()))
      (if (pair? args)
          (let ((arg (car args)))
            (loop (cdr args)
                  (+ idx 1)
                  (cons `(ffi#provided-mask ,(car arg) ,idx) acc)))
          acc))))

(eval-at-macroexpand
  (define (get-default-value arg)
    (if (null? (cddr arg))
        (case (cadr arg)
          ((int unsigned-long unsigned-int Bool long) 0)
          ((Window Pixmap Cursor Colormap) 'x#+none+)
          (else (error (string-append "Cannot determine default type for "
                                      (object->string (cadr arg))))))
        (caddr arg))))

(eval-at-macroexpand
  (define (symbol-append . s)
    (string->symbol (apply string-append (map symbol->string s)))))

(define-macro (ffi-define-type name type)
  (let* ((sym (string->symbol name))
         (ptr (string->symbol (string-append name "*")))
         (ptr/free (string->symbol (string-append name "*/" type)))
         (releaser (string-append type "_" name))
         (c-releaser (string-replace #\_ #\- releaser)))
    `(begin
       (c-declare
         ,(string-append
            "___SCMOBJ " c-releaser "(void *ptr)\n"
            "{\n"
            name " *p = ptr;\n"
            "#ifdef debug_free\n"
            "printf(\"" c-releaser "(%p)\\n\", p);\n"
            "fflush(stdout);\n"
            "#endif\n"
            ;"#ifdef really_free\n"
            (table-ref ffi-releasers type)
            ;"#endif\n"
            "return ___FIX(___NO_ERR);\n"
            "}\n"))
       (c-define-type ,sym ,name)
       (c-define-type ,ptr (pointer ,sym (,ptr)))
       (c-define-type ,ptr/free (pointer ,sym (,ptr) ,c-releaser)))))

(eval-at-macroexpand
  (define (lisp-name x)
    (let ((len (string-length x)))
      (let loop ((prev #\space)
                 (i 0)
                 (acc ""))
        (if (< i len)
            (let ((c (string-ref x i)))
              (loop 
                c
                (+ i 1)
                (cond ((and (char-upper-case? prev) (char-lower-case? c))
                       (string-set! acc (- (string-length acc) 1) #\-)
                       (string-append acc 
                                      (string (char-downcase prev)) 
                                      (string (char-downcase c))))
                      ((char=? c #\_) (string-append acc "-"))
                      (else (string-append acc (string (char-downcase c)))))))
            acc)))))

(eval-at-macroexpand
  (define (type-ptr? t)
    (let ((t (symbol->string t)))
      (char=? #\* (string-ref t (- (string-length t) 1))))))

(eval-at-macroexpand
  (define (struct-getter structname cstructname prefix name sname type)
    `(define ,(if (member type '(bool Bool))
                  (symbol-append
                    cstructname '- (string->symbol (lisp-name sname)) '?)
                  (symbol-append
                    cstructname '- (string->symbol (lisp-name sname))))
      (c-lambda (,(symbol-append structname '*))
                ,type
                ,(string-append (if (type-ptr? type)
                                    "___result_voidstar"
                                    "___result")
                                " = ___arg1->"
                                prefix
                                (symbol->string name)
                                ";")))))

(eval-at-macroexpand
  (define (struct-setter structname cstructname prefix name sname type)
    `(define ,(symbol-append 'set-
                             cstructname
                             '-
                             (string->symbol (lisp-name sname))
                             '!)
      (c-lambda (,(symbol-append structname '*) ,type)
                void
                ,(string-append "___arg1->"
                                prefix
                                (symbol->string name)
                                " = ___arg2;")))))

(eval-at-macroexpand
  (define (c-struct-expr type slots)
    (let ((cn (string->symbol (lisp-name (car type))))
          (n (string->symbol (car type)))
          (p (if (> (length type) 1)
                 (string-append (cadr type) ".")
                 "")))
      `(begin
        ,@(let loop ((slots slots)
                     (acc '()))
            (if (pair? slots)
                (let* ((slot (car slots))
                       (type (car slot))
                       (name (cadr slot))
                       (sname (symbol->string name)))
                  (loop (cdr slots)
                        (cons (struct-getter n cn p name sname type)
                              (cons (struct-setter n cn p name sname type)
                                    acc))))
                (reverse acc)))))))

(define-macro (define-c-struct type . slots)
  (c-struct-expr type slots))

(define-macro (define-c-const name type c-name)
  `(define ,name
     ((c-lambda () ,type ,(string-append "___result = " c-name ";")))))

(define-macro (define-x-setter name args key-args type c-body)
  (let ((types (append (map cadr args) '(unsigned-long) (map cadr key-args)))
        (lambda-key-args (map (lambda (a) `(,(car a) '())) key-args))
        (mask-var (gensym)))
    `(define (,name ,@(map car args) #!key ,@lambda-key-args)
      (let ((,mask-var (bitwise-ior ,@(make-provided-mask key-args))))
        ((c-lambda ,types ,type ,c-body)
         ,@(map car args)
         ,mask-var
         ,@(map (lambda (a)
                  `(ffi#provided-value ,(car a) ,(get-default-value a)))
                key-args))))))

(define-macro (define-x-pstruct-getter name args type code)
  (let ((ret-type (string->symbol (string-append type "*/release-rc"))))
    `(define ,name
       (c-lambda
         ,args
         ,ret-type
         ,(string-append
            type " data, *pdata;\n"
            code "\n"
            "XLIB_SCM_ALLOC_OBJ(pdata, " type ");
            *pdata = data;
            ___result_voidstar = pdata;")))))
