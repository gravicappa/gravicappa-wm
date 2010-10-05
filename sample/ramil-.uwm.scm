(include "~/dev/uwm/sample/utils.scm")
(include "~/dev/uwm/sample/pipe-command.scm")

(border-colour #xf0f0a0)
(selected-border-colour #xaf0000)
(border-width 2)
(bar-height 16)
(define prev-view (make-parameter ""))
(define *tags-fifo* (string-append "/tmp/gravicappa-wm.tags"
                                   (getenv "DISPLAY")))

(define logger '("log" "/home/ramil/stat/timing"))

(define (string-current-layout)
  (if (eq? (current-layout) fullscreen)
      "[ ]"
      "[]="))

(define (update-tag-status)
  (let loop ((tags (collect-all-tags))
             (str (string-append (string-current-layout)
                                 " / "
                                 (current-view)
                                 " / "
                                 (prev-view)
                                 " /")))
    (if (pair? tags)
        (loop (cdr tags)
              (if (or (string=? (car tags) (current-view))
                      (string=? (car tags) (prev-view)))
                  str
                  (string-append str " " (car tags))))
        (write-to-pipe str *tags-fifo*))))

(define (parse-tags str)
  (if (and (string? str) (positive? (string-length str)))
      (split-string #\space str)
      '()))

(define (tag c)
  (if (client? c)
      (for-each
        (lambda (t) (tag-client c t))
        (parse-tags (dmenu "Tag client:" (collect-all-tags))))))

(define (untag c)
  (if (client? c)
      (for-each
        (lambda (t) (untag-client c t))
        (parse-tags (dmenu "Untag client:" (client-tags c))))))

(define (view-tag tag)
  (if (and (string? tag) (positive? (string-length tag)))
      (begin
        (if (not (string=? (current-view) tag))
            (prev-view (current-view)))
        (view-clients tag (current-layout)))))

(define (toggle-fullscreen)
  (view-clients (current-view) (if (eq? (current-layout) fullscreen)
                                   (tiler 56/100)
                                   fullscreen)))

(define (current-time-seconds) 
  (inexact->exact (floor (time->seconds (current-time)))))

(define (update-timing-stats)
  (thread-start!
    (make-thread
      (lambda ()
        (pipe-command logger (list (string-append (current-time-seconds)
                                                  " switch_to "
                                                  (current-view))))))))

(define (dmenu title lines)
  (pipe-command (append (split-string #\space (getenv "DMENU"))
                                      (list "-p" title))
                        lines))

;; After start we see updated tagbar
(update-tag-status)

;; Updating tagbar every time it changes
(define update-tag-hook update-tag-status)

(set! shutdown-hook (lambda ()
                      (pipe-command logger (list (current-time-seconds)
                                                 " exit"))))

(bind-key x#+mod4-mask+ "Return" (lambda () (shell-command "xterm&")))
(bind-key x#+mod4-mask+ "h" focus-left)
(bind-key x#+mod4-mask+ "j" focus-before)
(bind-key x#+mod4-mask+ "k" focus-after)
(bind-key x#+mod4-mask+ "l" focus-right)
(bind-key x#+mod4-mask+ "a" focus-previous)
(bind-key x#+mod4-mask+ "o" (lambda () (zoom-client (current-client))))
(bind-key x#+mod4-mask+ "c" (lambda () (kill-client! (current-client))))
(bind-key x#+mod4-mask+ "p" (lambda () (shell-command "$DMENU_RUN &")))
(bind-key x#+mod4-mask+ "f" (lambda ()
                              (toggle-fullscreen)
                              (update-timing-stats)))
(bind-key x#+mod4-mask+ "m" (lambda () (tag (current-client))))
(bind-key x#+mod4-mask+ "r" (lambda ()
                              (view-tag (prev-view))
                              (update-timing-stats)))

(bind-key x#+mod4-mask+ "u" (lambda () (untag-client (current-client)
                                                     (current-view))))

(bind-key x#+mod4-mask+ "t" (lambda ()
                              (view-tag (dmenu "View:" (collect-all-tags)))
                              (update-timing-stats)))

(bind-key x#+mod4-mask+ "e"
          (lambda () (eval-from-string (dmenu "Eval:" '()))))

(bind-key (bitwise-ior x#+mod4-mask+ x#+control-mask+)
          "h"
          (lambda () (resize-client-rel! (current-client) 0 0 -50 0)))

(bind-key (bitwise-ior x#+mod4-mask+ x#+control-mask+)
          "j"
          (lambda () (resize-client-rel! (current-client) 0 0 0 50)))

(bind-key (bitwise-ior x#+mod4-mask+ x#+control-mask+)
          "k"
          (lambda () (resize-client-rel! (current-client) 0 0 0 -50)))

(bind-key (bitwise-ior x#+mod4-mask+ x#+control-mask+)
          "l"
          (lambda () (resize-client-rel! (current-client) 0 0 50 0)))

(bind-key (bitwise-ior x#+mod4-mask+ x#+shift-mask+)
          "h"
          (lambda () (resize-client-rel! (current-client) -50 0 0 0)))

(bind-key (bitwise-ior x#+mod4-mask+ x#+shift-mask+)
          "j"
          (lambda () (resize-client-rel! (current-client) 0 50 0 0)))

(bind-key (bitwise-ior x#+mod4-mask+ x#+shift-mask+)
          "k"
          (lambda () (resize-client-rel! (current-client) 0 -50 0 0)))

(bind-key (bitwise-ior x#+mod4-mask+ x#+shift-mask+)
          "l"
          (lambda () (resize-client-rel! (current-client) 50 0 0 0)))

(bind-key 0 "XF86AudioRaiseVolume"
          (lambda () (shell-command "amixer set Master 2%+ &")))

(bind-key 0 "XF86AudioLowerVolume"
          (lambda () (shell-command "amixer set Master 2%- &")))

(bind-key 0 "XF86Standby" (lambda () (shell-command "sudo pm-suspend &")))

(bind-key 0 "XF86AudioMute"
          (lambda () (shell-command "amixer set Master toggle &")))

(bind-key 0 "XF86MonBrightnessUp"
          (lambda () (shell-command "backlight_samsung 10+ &")))

(bind-key 0 "XF86MonBrightnessDown"
          (lambda () (shell-command "backlight_samsung 10- &")))
