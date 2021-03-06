(define (init-colour! c color display cmap)
  (let ((component (lambda (mask shift)
                     (arithmetic-shift (bitwise-and color mask) shift))))
    (cond ((string? color)
           (= (x-parse-color display cmap color c) 1))
          ((number? color)
           (set-x-color-red! c (component #xff0000 -8))
           (set-x-color-green! c (component #x00ff00 0))
           (set-x-color-blue! c (component #x0000ff 8))
           #t))))

(define get-colour
  (let ((cache (make-table)))
    (lambda (display screen color)
      (let ((cached (table-ref cache (cons (screen-id screen) color) #f)))
        (if cached
            cached
            (let ((cmap (x-default-colormap display (screen-id screen)))
                  (c (make-x-color-box)))
              (if (and (init-colour! c color display cmap)
                       (= (x-alloc-color display cmap c) 1))
                  (let ((c (x-color-pixel c)))
                    (table-set! cache (cons (screen-id screen) color) c)
                    c)
                  #f)))))))
