(define-structure client
  name 
  window 
  screen 
  tags 
  floating? 
  border
  x 
  y 
  w 
  h 
  old-border 
  fixed? 
  urgent? 
  fullscreen?
  basew 
  baseh
  incw
  inch
  maxw
  maxh
  minw
  minh
  mina
  maxa)

(define (client-wants-fullscreen? client)
  (and (eq? (client-w client) (screen-w (client-screen client)))
       (eq? (client-h client) (screen-h (client-screen client)))))

(define (fullscreen-client client)
  (client-border-set! client 0)
  (client-fullscreen?-set! client #t)
  (client-x-set! client (screen-x (client-screen client)))
  (client-y-set! client (screen-y (client-screen client))))

(define (hold-client-on-screen client)
  (let ((hold (lambda (x w ax aw b)
                (max ax 
                     (if (> (+ x w (* 2 b)) (+ ax aw))
                         (- (+ ax aw) w)
                         x))))
        (cborder (client-border client))
        (screen (client-screen client)))
    (client-x-set! client 
                   (hold (client-x client) (client-w client) 
                         (screen-x screen) (screen-w screen) border))
    (client-y-set! client 
                   (hold (client-y client) (client-h client) 
                         (screen-y screen) (screen-h screen) border))))

(define (tag-client client tags)
  #f)

(define (configure-client display c)
  (let ((ev (make-x-event))
        (win (client-window c)))
    (x-any-event-display-set! ev display)
    (x-any-event-type-set! ev configure-notify)
    (x-any-event-type-window-set! ev win)
    (x-any-event-type-event-set! ev win)
    (x-configure-event-x-set! ev (client-x c))
    (x-configure-event-y-set! ev (client-y c))
    (x-configure-event-width-set! ev (client-w c))
    (x-configure-event-height-set! ev (client-h c))
    (x-configure-event-border-width-set! ev (client-border c))
    (x-configure-event-above-set! ev +x-none+)
    (x-configure-event-override-redirect?-set! eh #f)
    (x-send-event display win #f structure-notify-mask ev)))

(define (update-size-hints! display c)
  (let* ((hints (x-get-wm-normal-hints display (client-window c)))
         (set? (lambda (flag) (bitwise-and (x-size-hints-flags hints) flag))))
    (cond ((set? +p-base-size+)
           (client-basew-set! c (x-size-hints-base-width hints))
           (client-baseh-set! c (x-size-hints-base-height hints)))
          ((set? +p-min-size+)
           (client-basew-set! c (x-size-hints-min-width hints))
           (client-baseh-set! c (x-size-hints-min-height hints)))
          (else
            (client-basew-set! c 0)
            (client-baseh-set! c 0)))
    (cond ((set? +p-resize-inc+)
           (client-incw-set! c (x-size-hints-width-inc hints))
           (client-inch-set! c (x-size-hints-height-inc hints)))
          (else (client-incw-set! c 0)
                (client-inch-set! c 0)))
    (cond ((set? +p-min-size+)
           (client-minw-set! c (x-size-hints-min-width hints))
           (client-minh-set! c (x-size-hints-min-height hints)))
          ((set? +p-base-size+)
           (client-minw-set! c (x-size-hints-base-width hints))
           (client-minh-set! c (x-size-hints-base-height hints)))
          (else (client-minw-set! c 0)
                (client-minh-set! c 0)))
    (cond ((set? +p-aspect+)
           (client-mina-set! c (/ (x-size-hints-min-aspect-x hints)
                                  (x-size-hints-min-aspect-y hints)))
           (client-maxa-set! c (/ (x-size-hints-max-aspect-x hints)
                                  (x-size-hints-max-aspect-y hints))))
          (else (client-mina-set! c 0)
                (client-maxa-set! c 0)))
    (client-fixed? c 
                   (and (positive? (client-maxw c))
                        (positive? (client-maxh c))
                        (positive? (client-minw c))
                        (positive? (client-minh c))
                        (eq (client-maxw c) (client-minw c))
                        (eq (client-maxh c) (client-minh c))))))
