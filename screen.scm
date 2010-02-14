(define-structure* screen
  id x y w h root display clients focus-stack view)

(define *screens* (list))

(define (current-screen)
  (car *screens*))

(define (current-view . args)
  (if (pair? args)
      (set-screen-view! (current-screen) (car args))
      (screen-view (current-screen))))

(define +root-event-mask+ (bitwise-ior +substructure-redirect-mask+
                                       +substructure-notify-mask+
                                       +button-press-mask+
                                       +enter-window-mask+
                                       +leave-window-mask+
                                       +structure-notify-mask+))

(define (init-screen disp i)
  (let* ((root (x-root-window disp i))
         (screen (make-screen id: i
                              x: 0
                              y: 0
                              w: (x-display-width disp i)
                              h: (x-display-height disp i)
                              root: root
                              display: disp
                              view: *initial-view*
                              clients: (list #f)
                              focus-stack: (list #f))))
    (x-change-property-atoms disp
                             root
                             (get-atom "_NET_SUPPORTED")
                             (list (get-atom "_NET_SUPPORTED")
                                   (get-atom "_NET_WM_NAME")))
    (x-change-window-attributes disp root event-mask: +root-event-mask+)
    (x-select-input disp root +root-event-mask+)
    screen))

(define (init-all-screens disp)
  (let ((num (x-screen-count disp)))
    (let loop ((i 0)
               (acc '()))
      (if (< i num)
          (loop (+ i 1) (cons (init-screen disp i) acc))
          (set! *screens* (reverse acc))))))

(define (find-screen parent)
  (find-if (lambda (s) (eq? (screen-root s) parent)) *screens*))

(define (find-client-on-screen window screen)
  (find-if (lambda (c) (eq? (client-window c) window))
           (cdr (screen-clients screen))))

(define (find-client window)
  (let loop ((s *screens*))
    (if (pair? s)
        (let ((c (find-client-on-screen window (car s))))
          (if c
              c
              (loop (cdr s))))
        #f)))

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
