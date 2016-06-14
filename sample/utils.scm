(define prev-tag "")

(define (eval-from-string str)
  (if (string? str)
      (with-exception-handler
        (lambda (e) #f)
        (lambda () (eval (with-input-from-string str read))))))

(define (split-string sep s)
  (let ((len (string-length s)))
    (let loop ((start 0)
               (i 0)
               (acc '()))
      (if (< i len)
          (if (char=? (string-ref s i) sep)
              (loop (+ i 1) (+ i 1) (if (< start i)
                                        (cons (substring s start i) acc)
                                        acc))
              (loop start (+ i 1) acc))
          (if (< start i)
              (reverse (cons (substring s start len) acc))
              (reverse acc))))))

(define (string-trim-right s pred)
  (let ((pred (cond ((procedure? pred) pred)
                    ((char? pred) (lambda (c) (char=? c pred)))))
        (len (string-length s)))
    (if (positive? len)
        (let loop ((i (- len 1)))
          (if (positive? i)
              (if (pred (string-ref s i))
                  (loop (- i 1))
                  (substring s 0 (+ i 1)))
              (substring s 0 (+ i 1))))
        "")))

(define (string-append-list sep lst)
  (if (pair? lst)
      (let loop ((s (car lst))
                 (lst (cdr lst)))
        (if (pair? lst)
            (loop (string-append s sep (car lst)) (cdr lst))
            s))))

(define (write-to-file-or-fail string filename)
  (with-exception-catcher
    (lambda (e) #f)
    (lambda ()
      (if (file-exists? filename)
          (with-output-to-file
            filename
            (lambda ()
              (display string)
              (newline))))
      #t)))

(define (write-to-pipe str filename)
  (if (not (write-to-file-or-fail str filename))
      (begin
        (thread-sleep! 1/100)
        (write-to-file-or-fail str filename))))

(define (view-tag tag)
  (if (and (string? tag) (positive? (string-length tag)))
      (begin
        (if (not (string=? current-tag tag))
            (set! prev-tag current-tag))
        (view-mwins tag current-layout))))

(define (view-prev-tag) (view-tag prev-tag))

(define (parse-tags str)
  (if (and (string? str) (positive? (string-length str)))
      (split-string #\space str)
      '()))

(define (tag m)
  (if (mwin? m)
      (for-each
        (lambda (t) (tag-mwin m t))
        (parse-tags (dmenu "Tag:" (collect-all-tags))))))

(define (untag m)
  (if (mwin? m)
      (for-each
        (lambda (t) (untag-mwin m t))
        (parse-tags (dmenu "Untag:" (mwin-tags m))))))

(define (toggle-fullscreen)
  (view-mwins current-tag
              (cond ((eq? current-layout fullscreen) tile)
                    (else (zoom-client current-mwin fullscreen)))))
