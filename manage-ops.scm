(define (focus-previous)
  (let ((ms (filter mwin-visible? (screen-mwins-list (current-screen)))))
    (if (and (pair? ms) (pair? (cdr ms)) (mwin? (cadr ms)))
        (focus-mwin (current-display) (cadr ms)))))

(define (focus-left)
  (let* ((s (current-screen))
         (m (filter mwin-visible? (screen-mwins-list s))))
    (if (and (pair? m) (mwin? (car m)))
        (focus-mwin (current-display) (car m)))))

(define (focus-right)
  (if current-mwin
      (let* ((s (current-screen))
             (m (filter mwin-visible? (screen-mwins-list s)))
             (f (filter mwin-visible? (screen-stack-list s))))
        (if (and (pair? m) (pair? (cdr m)) (pair? f) (pair? (cdr f))
                 (eq? current-mwin (car m)) (mwin? (cadr f)))
            (focus-mwin (current-display) (cadr f))))))

(define (find-mwin-rel test init mwins)
  (let loop ((mwins mwins)
             (prev init))
    (if (pair? mwins)
        (let ((found (test prev (car mwins))))
          (if found
              found
              (loop (cdr mwins) (car mwins))))
        #f)))

(define (find-mwin-before m mwins)
  (find-mwin-rel (lambda (cur prev) (if (eq? cur m) prev #f))
                   (last mwins)
                   mwins))

(define (find-mwin-after m mwins)
  (find-mwin-rel (lambda (cur prev) (if (eq? prev m) cur #f))
                   (last mwins)
                   mwins))

(define (focus-rel select m)
  (if m
      (let* ((mwins (screen-mwins-list (current-screen)))
             (next (select
                     m
                     (filter mwin-visible? mwins))))
        (if (mwin? next)
            (focus-mwin (current-display) next)))))

(define (focus-after)
  (focus-rel find-mwin-after current-mwin))

(define (focus-before)
  (focus-rel find-mwin-before current-mwin))

(define (nth-mwin i)
  (let loop ((m (filter mwin-visible? (screen-mwins-list (current-screen))))
             (j 1))
    (cond ((not (pair? m)) #f)
          ((= i j) (car m))
          (#t (loop (cdr m) (+ j 1))))))

(define (focus-nth i)
  (let ((m (nth-mwin i)))
    (if (mwin? m)
        (focus-mwin (current-display) m))))

(define (zoom-mwin mwin)
  (if (mwin? mwin)
      (let* ((s (current-screen))
             (mwins (filter mwin-tiled? (screen-mwins-list s))))
        (if (and (pair? mwins)
                 (not (eq? mwin (car mwins))))
            (move-to-mwin-top! mwin s))
        (arrange-screen (current-display) s))))

(define (collect-all-tags)
  (let ((tags-table (make-table)))
    (do ((i 0 (+ i 1)))
        ((= i (vector-length *screens*)))
      (for-each
        (lambda (m)
          (for-each
            (lambda (t) (table-set! tags-table t #t))
            (mwin-tags m)))
        (screen-mwins-list (vector-ref *screens* i))))
    (map car (table->list tags-table))))

(define (view-mwins tag proc)
  (set! current-tag tag)
  (set! current-layout proc)
  (update-tag-hook)
  (let ((s (current-screen)))
    (arrange-screen (current-display) s)))

(define (tag-mwin m tag)
  (if (and (mwin? m) (string? tag))
      (let ((tags (mwin-tags m)))
        (if (not (member tag tags))
            (begin
              (set-mwin-tags! m (cons tag tags))
              (tag-hook m tag)
              (update-tag-hook)
              (update-layout))))))

(define (untag-mwin m tag)
  (if (and m (string? tag))
      (let ((new (remove-if (lambda (t) (string=? t tag)) (mwin-tags m))))
        (if (pair? new)
            (begin
              (untag-hook m tag)
              (set-mwin-tags! m new)
              (update-tag-hook)
              (update-layout))))))

(define (resize-rel m dx dy dw dh)
  (if (and (mwin? m) (mwin-floating? m))
      (let ((x (+ (mwin-x m) dx))
            (y (+ (mwin-y m) dy))
            (w (+ (mwin-w m) dw))
            (h (+ (mwin-h m) dh)))
        (keep-rect-on-screen x y w h (mwin-border m) (current-screen)
                             (lambda (x y) (resize-w/hints m x y w h)))
        (do () ((not (x-check-mask-event (current-display)
                                         x#+enter-window-mask+)))))))

(define (mwin-property m)
  (if (mwin? m)
      (x-get-text-property-list (current-display)
                                (current-screen)
                                (mwin-window m))
      '()))
