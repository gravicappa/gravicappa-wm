(include "sort.scm")

(define (client-edge c dir)
  (let ((x1 (client-x c))
        (y1 (client-y c))
        (x2 (+ (client-x c) (client-w c)))
        (y2 (+ (client-y c) (client-h c))))
    (case dir
      ((up) (values x1 x2 y1))
      ((down) (values x1 x2 y2))
      ((left) (values y1 y2 x1))
      ((right) (values y1 y2 x2)))))

(define (opposite dir)
  (case dir
    ((up) 'down) ((down) 'up) ((left) 'right) ((right) 'left)))

(define (find-client* start end dist clients dir weight ret)
  (if (pair? clients)
      (call-with-values
        (lambda () (client-edge (car clients) dir))
        (lambda (start1 end1 dist1)
          (let ((w (abs (- dist dist1))))
            (if (and (< (abs (- dist dist1)) 100) (> w weight))
                (find-client*
                  start end dist (cdr clients) dir w (car clients))
                (find-client* start end dist (cdr clients) dir weight ret)))))
      ret))

(define (find-client direction client in)
  (if (and client in)
      (call-with-values
        (lambda () (client-edge client direction))
        (lambda (start end dist)
          (find-client* start end dist in (opposite direction) 0 #f)))
      #f))

(define (focus-client direction #!optional (client *selected*))
  (if client
      (let* ((visible (filter client-visible?
                              (screen-focus-stack (client-screen client))))
             (next (find-client direction client visible)))
        (if next
            (run-hook *focus-hook* (client-display next) next)))))

(define (focus-previous)
  (if *selected*
      (let ((v (filter client-visible?
                       (screen-focus-stack (client-screen *selected*)))))
        (if (and (pair? (cdr v)) (cadr v))
            (run-hook *focus-hook* (client-display (cadr v)) (cadr v))))))

(define (find-client-after c clients)
  (let loop ((clients clients)
             (old (last clients)))
    (if (pair? clients)
        (if (eq? c old)
            (car clients)
            (loop (cdr clients) (car clients))))))

(define (find-client-before c clients)
  (let loop ((clients clients)
             (old (last clients)))
    (if (pair? clients)
        (if (eq? c (car clients))
            old
            (loop (cdr clients) (car clients))))))

(define (focus-in-list dir #!optional (c *selected*))
  (if c
      (let* ((clients (screen-clients (client-screen c)))
             (next ((case dir
                      ((after) find-client-after)
                      ((before) find-client-before))
                    c
                    (filter client-visible? clients))))
        (if next
            (run-hook *focus-hook* (client-display next) next)))))

(define (zoom-client #!optional (client *selected*))
  (when client
    (let ((clients (filter client-tiled?
                           (screen-clients (client-screen client)))))
      (if (and (eq? client (car clients))
               (pair? (cdr clients))
               (cadr clients))
          (to-stack-top (cadr clients))
          (to-stack-top client))
      (run-hook *arrange-hook*
                (client-display client)
                (client-screen client)))))

(define (collect-tags clients tags)
  (if (pair? clients)
      (collect-tags (cdr clients) (append (client-tags (car clients)) tags))
      tags))

(define (collect-all-tags)
  (let loop ((screens *screens*)
             (tags '()))
    (if (pair? screens)
        (loop (cdr screens)
              (collect-tags (screen-clients (car screens)) tags))
        (remove-duplicates tags string=?-hash eq?))))

(define (view-clients tag)
  (set! *current-view* tag)
  (run-hook *retag-hook*)
  (let ((s (current-screen)))
    (run-hook *arrange-hook* (screen-display s) s)))

(define (collect-tagged-clients tag)
  (let loop ((screens *screens*)
             (clients '()))
    (if (pair? screens)
        (loop (cdr screens)
              (append (filter (lambda (c) (client-tagged? c tag))
                              (screen-clients (car screens)))
                      clients))
        clients)))

(define (tag-client c tag)
  (if (and c (string? tag))
      (let ((tags (client-tags c)))
        (if (not (member tag tags))
            (begin
              (client-tags-set! c (cons tag tags))
              (run-hook *retag-hook*)
              (run-hook *arrange-hook*
                        (client-display c)
                        (client-screen c)))))))

(define (untag-client c tag)
  (let ((new-tags (remove-if (lambda (t) (string=? t tag)) (client-tags c))))
    (if (pair? new-tags)
        (begin
          (client-tags-set! c new-tags)
          (run-hook *retag-hook*)
          (run-hook *arrange-hook* (client-display c) (client-screen c))))))

(define (mass-untag-clients tag)
  (let ((clients (collect-tagged-clients tag)))
    (for-each (lambda (c) (untag-client c tag)) clients)
    (let ((s (current-screen)))
      (run-hook *retag-hook*)
      (run-hook *arrange-hook* (screen-display s) s))))

(define (resize-client-by c dx dy dw dh)
  (when (and c (client-floating? c))
    (client-x-set! c (+ (client-x c) dx))
    (client-y-set! c (+ (client-y c) dy))
    (client-w-set! c (+ (client-w c) dw))
    (client-h-set! c (+ (client-h c) dh))
    (hold-client-on-screen c)
    (resize-client c (client-x c) (client-y c) (client-w c) (client-h c))))

