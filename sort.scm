
(define (qsort lst test)
  (define (partition lst pivot k)
    (let loop ((lst lst)
               (smaller '())
               (greater '()))
      (cond
       ((null? lst)
        (k smaller greater))
       ((test (car lst) pivot)
        (loop (cdr lst)
              (cons (car lst) smaller)
              greater))
       (else
        (loop (cdr lst)
              smaller
              (cons (car lst) greater))))))

  (define (qs lst sorted)
    (if (null? lst)
        sorted
        (let ((pivot (car lst))
              (rest (cdr lst)))
          (partition rest
                     pivot
                     (lambda (smaller greater)
                       (qs smaller
                           (cons pivot
                                 (qs greater sorted))))))))

  (qs lst '()))

(define (remove-duplicates lst key test)
  (let ((sorted (qsort lst (lambda (a b) (eq? (key a) (key b))))))
    (if (pair? sorted)
        (let loop ((lst (cdr sorted))
                   (prev (car sorted))
                   (acc (list (car sorted))))
          (if (pair? lst)
              (if (test (key (car lst)) (key prev))
                  (loop (cdr lst) (car lst) acc)
                  (loop (cdr lst) (car lst) (cons (car lst) acc)))
              (reverse acc)))
        sorted)))
