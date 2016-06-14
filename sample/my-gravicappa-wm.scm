;; including library where (un)tag, view-tag, update-tag-status,
;; toggle-fullscreen, eval-from-string, split-string are defined
(load "~/d/gravicappa-wm/sample/utils.scm")
(load "~/d/gravicappa-wm/sample/pipe-command.scm")
(load "~/d/gravicappa-wm/sample/dmenu.scm")

(set! border-colour #xf0e7e7)
(set! selected-border-colour #xf09000)
(set! border-width 1)
(set! gap 1)

(define *tags-fifo*
  (string-append "/tmp/gravicappa-wm.tags" (getenv "DISPLAY")))
(define *timing-fifo*
  (string-append "/tmp/ns." (getenv "USER") "/timing" (getenv "DISPLAY")))

(define (string-current-layout)
  (if (eq? current-layout fullscreen)
      "[ ]"
      "[]="))

(define (update-tag-status)
  (let loop ((tags (collect-all-tags))
             (str (string-append current-tag
                                 " "
                                 (string-current-layout)
                                 " <"
                                 prev-tag
                                 ">")))
    (if (pair? tags)
        (loop (cdr tags)
              (if (or (string=? (car tags) current-tag)
                      (string=? (car tags) prev-tag))
                  str
                  (string-append str " " (car tags))))
        (write-to-pipe str *tags-fifo*))))

(define (tm-switch-to) 
  (write-to-pipe (string-append "switch_to " current-tag) *timing-fifo*))

;; After start we update status bar
(update-tag-status)

;; Update tagbar every time it changes
(define update-tag-hook update-tag-status)

(bind-key x#+mod4-mask+ "Return" (lambda () (shell-command "st&")))
(bind-key x#+mod4-mask+ "h" focus-left)
(bind-key x#+mod4-mask+ "j" focus-before)
(bind-key x#+mod4-mask+ "k" focus-after)
(bind-key x#+mod4-mask+ "l" focus-right)
(bind-key x#+mod4-mask+ "o" (lambda () (zoom-mwin current-mwin)))
(bind-key x#+mod4-mask+ "c" (lambda () (kill-mwin current-mwin)))
(bind-key x#+mod4-mask+ "p" (lambda () (shell-command "dmenu_run&")))
(bind-key x#+mod4-mask+ "f" toggle-fullscreen)
(bind-key x#+mod4-mask+ "m" (lambda () (tag current-mwin)))
(bind-key x#+mod4-mask+ "r" (lambda ()
                              (view-prev-tag)
                              (tm-switch-to)))

(bind-key x#+mod4-mask+ "u" (lambda () (untag-mwin current-mwin current-tag)))

(bind-key x#+mod4-mask+ "t" (lambda ()
                              (view-tag (dmenu "View:" (collect-all-tags)))
                              (tm-switch-to)))

(bind-key x#+mod4-mask+ "e"
          (lambda () (eval-from-string (dmenu "Eval:" '()))))

(bind-key (bitwise-ior x#+mod4-mask+ x#+control-mask+)
          "h"
          (lambda () (resize-rel current-mwin 0 0 -50 0)))

(bind-key (bitwise-ior x#+mod4-mask+ x#+control-mask+)
          "j"
          (lambda () (resize-rel current-mwin 0 0 0 50)))

(bind-key (bitwise-ior x#+mod4-mask+ x#+control-mask+)
          "k"
          (lambda () (resize-rel current-mwin 0 0 0 -50)))

(bind-key (bitwise-ior x#+mod4-mask+ x#+control-mask+)
          "l"
          (lambda () (resize-rel current-mwin 0 0 50 0)))

(bind-key (bitwise-ior x#+mod4-mask+ x#+shift-mask+)
          "h"
          (lambda () (resize-rel current-mwin -50 0 0 0)))

(bind-key (bitwise-ior x#+mod4-mask+ x#+shift-mask+)
          "j"
          (lambda () (resize-rel current-mwin 0 50 0 0)))

(bind-key (bitwise-ior x#+mod4-mask+ x#+shift-mask+)
          "k"
          (lambda () (resize-rel current-mwin 0 -50 0 0)))

(bind-key (bitwise-ior x#+mod4-mask+ x#+shift-mask+)
          "l"
          (lambda () (resize-rel current-mwin 50 0 0 0)))

(bind-key 0 "XF86Sleep" (lambda () (shell-command "sudo pm-suspend &")))

;(bind-key 0 "XF86AudioRaiseVolume"
;          (lambda () (shell-command "amixer set Master 2%+ &")))

;(bind-key 0 "XF86AudioLowerVolume"
;          (lambda () (shell-command "amixer set Master 2%- &")))

;(bind-key 0 "XF86AudioMute"
;          (lambda () (shell-command "amixer set Master toggle &")))

(bind-key 0 "XF86TouchpadOn"
          (lambda () (shell-command "synclient TouchpadOff=0")))

(bind-key 0 "XF86TouchpadOff"
          (lambda () (shell-command "synclient TouchpadOff=1")))

(bind-key x#+mod4-mask+ "g" (lambda () (shell-command "runner&")))

(bind-key x#+mod4-mask+ "b" (lambda () (shell-command "xungrab&")))
