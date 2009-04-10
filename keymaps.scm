(include "xlib/Xlib#.scm")

(define *ignored-modifiers* (list +lock-mask+
                                  +mod2-mask+
                                  (bitwise-ior +lock-mask+ +mod2-mask+)))

(define *top-map* (cons #f '()))

(define *modifiers* `((#\S . ,+shift-mask+)
                      (#\C . ,+control-mask+)
                      (#\s . ,+mod4-mask+)
                      (#\M . ,+mod1-mask+)))

(define *key-names* '(("RET" . "Return")
                      ("ESC" . "Escape")
                      ("TAB" . "Tab")
                      ("DEL" . "BackSpace")
                      ("SPC" . "space")
                      ("!" . "exclam")
                      ("\"" . "quotedbl")
                      ("$" . "dollar")
                      ("%" . "percent")
                      ("&" . "ampersand")
                      ("'" . "apostrophe")
                      ("`" . "grave")
                      ("&" . "ampersand")
                      ("(" . "parenleft")
                      (")" . "parenright")
                      ("*" . "asterisk")
                      ("+" . "plus")
                      ("," . "comma")
                      ("-" . "minus")
                      ("." . "period")
                      ("/" . "slash")
                      (":" . "colon")
                      (";" . "semicolon")
                      ("<" . "less")
                      ("=" . "equal")
                      (">" . "greater")
                      ("?" . "question")
                      ("@" . "at")
                      ("[" . "bracketleft")
                      ("\\" . "backslash")
                      ("]" . "bracketright")
                      ("^" . "asciicircum")
                      ("_" . "underscore")
                      ("#" . "numbersign")
                      ("{" . "braceleft")
                      ("|" . "bar")
                      ("}" . "braceright")
                      ("~" . "asciitilde")))

(define (mod-from-name str)
  (let ((mod (assoc (string-ref str 0) *modifiers*)))
    (if mod
        (cdr mod)
        0)))

(define (make-modifier mods)
  (apply bitwise-ior mods))

(define (parse-modifiers mod-names)
  (apply bitwise-ior (remove #f (map mod-from-name mod-names))))

(define (parse-key key)
  (let ((key-name (assoc key *key-names*)))
    (x-string-to-keysym (or (and (pair? key-name) (cdr key-name)) key))))

(define (split-string sep)
  (lambda (str)
    (call-with-input-string
      str
      (lambda (p)
        (read-all p (lambda (p) (read-line p sep)))))))

(define (last <list>)
  (if (pair? <list>)
      (if (pair? (cdr <list>))
          (last (cdr <list>))
          (car <list>))
      #f))

(define (butlast <list>)
  (let loop ((<list> <list>)
             (acc '()))
    (if (pair? <list>)
        (if (pair? (cdr <list>))
            (loop (cdr <list>) (cons (car <list>) acc))
            (reverse acc))
        '())))

(define (remove-spaces str)
  (list->string (remove #\space (string->list str))))

(define (parse-keychord chord)
  (let ((spec ((split-string #\-) chord)))
    (if (cdr spec)
        (cons (parse-key (last spec)) (parse-modifiers (butlast spec)))
        (cons (parse-key (car spec)) 0))))

(define (parse-keymap str)
  (let ((chords ((split-string #\space) str)))
    (map parse-keychord chords)))

(define kbd parse-keymap)

(define (clean-mod mod)
  (bitwise-and mod (bitwise-not (make-modifier *ignored-modifiers*))))

(define (gc-bindings binds #!optional acc)
  (let ((bind (car binds)))
    (cond
      ((null? binds) acc)
      ((null? (cdr bind)) (gc-bindings (cdr binds) acc))
      ((not (pair? (cdr bind))) (gc-bindings (cdr binds) (cons bind acc)))
      (else (let ((b (gc-bindings (cdr bind))))
              (gc-bindings (cdr binds) (if b
                                           (cons (cons (car bind) b) acc)
                                           acc)))))))

(define (tree-from-list lst value)
  (cond ((null? lst) '())
        ((null? (cdr lst)) (cons (car lst) value))
        (else (cons (car lst) (list (tree-from-list (cdr lst) value))))))

(define (add-to-tree item value binds #!optional (acc '()))
  (let ((b (if (pair? binds) (car binds) '())))
    (cond
      ((and (null? item) (not (pair? binds)) (null? acc)) value)
      ((null? item) acc)
      ((null? binds) (append (list (tree-from-list item value)) binds acc))
      ((equal? (car item) (car b))
       (append
         (cdr binds)
         (list (cons (car b) (add-to-tree (cdr item) value (cdr b) '())))
         acc))
      (else (add-to-tree item value (cdr binds) (cons b acc))))))

(define (bind-key map keys fn)
  (if fn
      (add-to-tree keys fn map)
      (gc-bindings (add-to-tree keys fn map))))

(define (define-key map keys fn)
  (set-cdr! map (bind-key (cdr map) keys fn)))

(define (find-bindings key mod map)
  (find-if (lambda (b)
             (let ((b (car b)))
               (and (eq? key (car b)) (eq? mod (cdr b)))))
           map))

