(define (focus-previous)
  (let ((c (filter client-visible? (screen-stack (current-screen)))))
    (if (and (pair? (cdr c)) (client? (cadr c)))
        (focus-client (current-display) (cadr c)))))

(define (focus-left)
  (let* ((s (current-screen))
         (c (filter client-visible? (cdr (screen-clients s)))))
    (if (and (positive? (length c)) (client? (car c)))
        (focus-client (current-display) (car c)))))

(define (focus-right)
  (if (current-client)
      (let* ((s (current-screen))
             (c (filter client-visible? (cdr (screen-clients s))))
             (f (filter client-visible? (cdr (screen-stack s)))))
        (if (and (pair? c) (pair? (cdr c)) (pair? f) (pair? (cdr f))
                 (eq? (current-client) (car c)) (client? (cadr f)))
            (focus-client (current-display) (cadr f))))))

(define (find-client-rel test init clients)
  (let loop ((clients clients)
             (prev init))
    (if (pair? clients)
        (let ((found (test prev (car clients))))
          (if found
              found
              (loop (cdr clients) (car clients))))
        #f)))

(define (find-client-before c clients)
  (find-client-rel (lambda (cur prev) (if (eq? cur c) prev #f))
                   (last clients)
                   clients))

(define (find-client-after c clients)
  (find-client-rel (lambda (cur prev) (if (eq? prev c) cur #f))
                   (last clients)
                   clients))

(define (focus-rel select c)
  (if c
      (let* ((clients (screen-clients (current-screen)))
             (next (select
                     c
                     (filter client-visible? clients))))
        (if (client? next)
            (focus-client (current-display) next)))))

(define (focus-after)
  (focus-rel find-client-after (current-client)))

(define (focus-before)
  (focus-rel find-client-before (current-client)))

(define (zoom-client client)
  (if (client? client)
      (let* ((s (current-screen))
             (clients (filter client-tiled? (screen-clients s))))
        (if (and (pair? clients)
                 (eq? client (car clients))
                 (pair? (cdr clients))
                 (cadr clients))
            (move-client-to-top! (cadr clients) (screen-clients s))
            (move-client-to-top! client (screen-clients s)))
        (arrange-screen (current-display) s))))

(define (collect-all-tags)
  (let ((tags-table (make-table)))
    (do ((i 0 (+ i 1)))
        ((= i (vector-length *screens*)))
      (for-each
        (lambda (c)
          (for-each
            (lambda (t) (table-set! tags-table t #t))
            (client-tags c)))
        (cdr (screen-clients (vector-ref *screens* i)))))
    (map car (table->list tags-table))))

(define (view-clients tag proc)
  (set-screen-view! (current-screen) tag)
  (set! current-layout (lambda () proc))
  (update-tag-hook)
  (let ((s (current-screen)))
    (arrange-screen (current-display) s)))

(define (tag-client c tag)
  (if (and (client? c) (string? tag))
      (let ((tags (client-tags c)))
        (if (not (member tag tags))
            (begin
              (set-client-tags! c (cons tag tags))
              (update-tag-hook)
              (arrange-screen (current-display) (current-screen)))))))

(define (untag-client c tag)
  (if (and c (string? tag))
      (let ((new (remove-if (lambda (t) (string=? t tag)) (client-tags c))))
        (if (pair? new)
            (begin
              (set-client-tags! c new)
              (update-tag-hook)
              (arrange-screen (current-display) (current-screen)))))))

(define (collect-tagged-clients tag)
  (let loop ((screens *screens*)
             (clients '()))
    (if (pair? screens)
        (loop (cdr screens)
              (append (filter (lambda (c) (client-tagged? c tag))
                              (cdr (screen-clients (car screens))))
                      clients))
        clients)))

(define (untag-all-clients tag)
  (let ((clients (collect-tagged-clients tag)))
    (for-each (lambda (c) (untag-client c tag)) clients)))

(define (resize-client-rel! c dx dy dw dh)
  (if (and (client? c) (client-floating? c))
      (let ((x (+ (client-x c) dx))
            (y (+ (client-y c) dy))
            (w (+ (client-w c) dw))
            (h (+ (client-h c) dh)))
        (keep-rect-on-screen x y w h (client-border c) (current-screen)
                             (lambda (x y)
                               (resize-client! c x y w h))))))
