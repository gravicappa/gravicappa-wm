
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
  (when (and client in)
    (call-with-values
      (lambda () (client-edge client direction))
      (lambda (start end dist)
        (find-client* start end dist in (opposite direction) 0 #f)))))

(define (focus-client direction #!optional (client *selected*))
  (when client
    (let* ((visible (filter client-visible?
                            (screen-focus-stack (client-screen client))))
           (next (find-client direction client visible)))
      (when next
        (run-hook *focus-hook* (client-display next) next)))))

(define (focus-previous)
  (when *selected*
    (let* ((visible (filter client-visible?
                            (screen-focus-stack (client-screen *selected*))))
           (prev (cadr visible)))
      (when prev
        (run-hook *focus-hook* (client-display prev) prev)))))

(define (find-client-after c clients)
  (let loop ((clients clients)
             (old (last clients)))
    (when (pair? clients)
      (if (eq? c old)
          (car clients)
          (loop (cdr clients) (car clients))))))

(define (find-client-before c clients)
  (let loop ((clients clients)
             (old (last clients)))
    (when (pair? clients)
      (if (eq? c (car clients))
          old
          (loop (cdr clients) (car clients))))))

(define (focus-in-list dir #!optional (c *selected*))
  (when c
    (let* ((clients (screen-clients (client-screen c)))
           (next ((case dir
                    ((after) find-client-after)
                    ((before) find-client-before))
                  c
                  (filter client-visible? clients))))
      (when next
        (run-hook *focus-hook* (client-display next) next)))))

(define (zoom-client #!optional (client *selected*))
  (when client
    (let ((clients (filter client-tiled?
                           (screen-clients (client-screen client)))))
      (if (and (eq? client (car clients)) (cadr clients))
          (to-stack-top (cadr clients))
          (to-stack-top client))
      (run-hook *arrange-hook*
                (client-display client)
                (client-screen client)))))