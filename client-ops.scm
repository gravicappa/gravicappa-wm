
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
    ((up) down) ((down) up) ((left) right) ((right) left)))

(define (find-client* start end dist clients dir weight ret)
  (if clients
      (call-with-values 
        (lambda () (client-edge (car clients) dir))
        (lambda (start1 end1 dist1)
          (let ((w (- (min end end1) (max start start1))))
            (if (and (< (abs (- dist dist1)) 10) (> w weight))
                (find-client* 
                  start end dist (cdr clients) dir w (car clients))
                (find-client* start end dist (cdr clients) dir weight ret)))))
      ret))

(define (find-client direction client in)
  (when (and client in)
    (call-with-values
      (lambda () (client-edge client direction))
      (lambda (start end dist)
        (find-client* start end dist in (opposite direction))))))

(define (focus-client direction #!optional (client *selected*))
  (when client
    (let* ((visible (filter client-visible? 
                            (screen-focus-stack (client-screen client))))
           (next (find-client direction client visible)))
      (when next
        (focus next)))))

(define (focus-previous)
  (when *selected*
    (let* ((visible (filter client-visible? 
                            (screen-focus-stack (client-screen client))))
           (prev (cadr visible)))
      (when prev
        (focus prev)))))

(define (zoom-client #!optional (client *selected*))
  (when client
    (let ((clients (filter client-tiled? 
                           (screen-focus-stack (client-screen client)))))
      (if (and (eq client (car clients)) (cadr clients))
          (to-stack-top (cadr clients))
          (to-stack-top client)))))
