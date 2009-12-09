(define (focus-previous)
  (if (current-client)
      (let ((c (filter client-visible?
                       (screen-focus-stack
                         (client-screen (current-client))))))
        (if (and (pair? (cdr c)) (client? (cadr c)))
            (focus-client (client-display (cadr c)) (cadr c))))))

(define (focus-left)
  (if (current-client)
      (let* ((s (client-screen (current-client)))
             (c (filter client-visible? (cdr (screen-clients s)))))
        (if (and (positive? (length c)) (client? (car c)))
            (focus-client (client-display (car c)) (car c))))))

(define (focus-right)
  (if (current-client)
      (let* ((s (client-screen (current-client)))
             (c (filter client-visible? (cdr (screen-clients s))))
             (f (filter client-visible? (cdr (screen-focus-stack s)))))
        (if (and (pair? c) (pair? (cdr c)) (pair? f) (pair? (cdr f))
                 (eq? (current-client) (car c)) (client? (cadr f)))
            (focus-client (client-display (cadr f)) (cadr f))))))

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
      (let* ((clients (screen-clients (client-screen c)))
             (next (select
                     c
                     (filter client-visible? clients))))
        (if (client? next)
            (focus-client (client-display next) next)))))

(define (focus-after)
  (focus-rel find-client-after (current-client)))

(define (focus-before)
  (focus-rel find-client-before (current-client)))

(define (zoom-client client)
  (if client
      (let* ((s (client-screen client))
             (clients (filter client-tiled? (screen-clients s))))
        (if (and (eq? client (car clients))
                 (pair? (cdr clients))
                 (cadr clients))
            (move-client-to-top! (cadr clients) (screen-clients s))
            (move-client-to-top! client (screen-clients s)))
        (arrange-screen (client-display client) s))))

(define (collect-all-tags)
  (let ((tags-table (make-table)))
    (for-each
      (lambda (s)
        (for-each
          (lambda (c)
            (for-each
              (lambda (t) (table-set! tags-table t #t))
              (client-tags c)))
          (cdr (screen-clients s))))
      *screens*)
    (map car (table->list tags-table))))

(define (view-clients tag)
  (current-view tag)
  (run-hook *update-tag-hook*)
  (let ((s (current-screen)))
    (arrange-screen (screen-display s) s)))

(define (tag-client c tag)
  (if (and c (string? tag))
      (let ((tags (client-tags c)))
        (if (not (member tag tags))
            (begin
              (set-client-tags! c (cons tag tags))
              (run-hook *update-tag-hook*)
              (arrange-screen (client-display c) (client-screen c)))))))

(define (untag-client c tag)
  (if (and c (string? tag))
      (let ((new (remove-if (lambda (t) (string=? t tag)) (client-tags c))))
        (if (pair? new)
            (begin
              (set-client-tags! c new)
              (run-hook *update-tag-hook*)
              (arrange-screen (client-display c) (client-screen c)))))))

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
  (if (and c (client-floating? c))
      (begin
        (set-client-x! c (+ (client-x c) dx))
        (set-client-y! c (+ (client-y c) dy))
        (set-client-w! c (+ (client-w c) dw))
        (set-client-h! c (+ (client-h c) dh))
        (hold-client-on-screen! c)
        (resize-client! 
          c (client-x c) (client-y c) (client-w c) (client-h c)))))
