
(define-structure screen
  id x y w h root clients focus-stack)

(define *screens* '())
(define *current-screen* #f)

(define (current-screen)
  (car *screens*))

(define +root-event-mask+ (bitwise-ior +substructure-redirect-mask+
                                       +substructure-notify-mask+
                                       +button-press-mask+
                                       +enter-window-mask+
                                       +leave-window-mask+
                                       +structure-notify-mask+))

(define (init-single-screen display i)
  (let* ((root (x-root-window display i))
         (screen (make-screen i
                              0
                              0
                              (x-display-width display i)
                              (x-display-height display i)
                              root
                              '()
                              '())))
    (x-change-window-attributes display 
                                root 
                                event-mask: +root-event-mask+)
		(x-select-input display root +root-event-mask+)
    (set! *current-screen* screen)
		screen))

(define (init-screens display)
	(let ((num (x-screen-count display)))
		(set!  *screens*
					(let loop ((i 0)
										 (screens '()))
						(if (< i num)
								(loop (+ 1 i) (cons (init-single-screen display i) screens))
								(reverse screens))))))

(add-hook *internal-startup-hook* 'init-screens)

(define (find-screen parent)
  (find-if (lambda (s) (eq? (screen-root s) parent)) *screens*))

(define (client-from-window window screen)
  (find-if (lambda (c) (eq? (client-window c) window))
           (screen-clients screen)))

(define (client-from-window* window)
  (let loop ((screens *screens*))
    (when (pair? screens)
      (let ((c (client-from-window window (car screens))))
        (if c
            c
            (loop (cdr screens)))))))
