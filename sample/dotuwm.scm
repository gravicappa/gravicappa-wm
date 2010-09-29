;; including library where pipe-command, (un)tag, view-tag,
;; update-tag-status, toggle-fullscreen, eval-from-string, split-string
;; are defined.
(include "~/dev/uwm/sample/utils.scm")

(border-colour #xf0f0a0)
(selected-border-colour #xaf0000)
(border-width 2)
(bar-height 16)
(tile-ratio 56/100)

(define (update-timing-stats)
  (let* ((sec (inexact->exact (floor (time->seconds (current-time)))))
         (view "web")
         (s (string-append "echo "
                           (number->string sec)
                           " '"
                           (current-view)
                           "' >> ~/stat/timings &")))
    (shell-command s)))

(define (dmenu title thunk)
  (pipe-command (append (split-string #\space (getenv "DMENU"))
                                      (list "-p" title))
                        thunk))

;; After start we see updated tagbar
(update-tag-status)

;; Updating tagbar every time it changes
(define update-tag-hook update-tag-status)

;; All hooks are:
;; * shutdown-hook — is called with no arguments on exit
;; * (currently not used) manage-hook — is called with 
;;   (display window window-attrib screen) arguments when new window is managed.
;; * (currently not used) unmanage-hook — is called with (client)
;;   argument when window is unmanaged.
;; * update-tag-hook — is called with no arguments when taglist is updated.
;; * apply-rules-hook — is called with (client classname) arguments when
;;   new client is created before it is mapped. Automatic tagging is
;;   done here.

(bind-key x#+mod4-mask+ "Return" (lambda () (shell-command "xterm&")))
(bind-key x#+mod4-mask+ "h" focus-left)
(bind-key x#+mod4-mask+ "j" focus-before)
(bind-key x#+mod4-mask+ "k" focus-after)
(bind-key x#+mod4-mask+ "l" focus-right)
(bind-key x#+mod4-mask+ "a" focus-previous)
(bind-key x#+mod4-mask+ "o" (lambda () (zoom-client (current-client))))
(bind-key x#+mod4-mask+ "c" (lambda () (kill-client! (current-client))))
(bind-key x#+mod4-mask+ "p" (lambda () (shell-command "$DMENU_RUN &")))
(bind-key x#+mod4-mask+ "f" toggle-fullscreen)
(bind-key x#+mod4-mask+ "m" (lambda () (tag (current-client))))
(bind-key x#+mod4-mask+ "r" (lambda () (view-tag (prev-view))))

(bind-key x#+mod4-mask+ "u" (lambda () (untag-client (current-client)
                                                     (current-view))))

(bind-key x#+mod4-mask+ "t" (lambda ()
                              (view-tag (dmenu "View:" collect-all-tags))
                              (update-timing-stats)))

(bind-key x#+mod4-mask+ "e"
          (lambda () (eval-from-string (dmenu "Eval:" (lambda () '())))))

(bind-key (bitwise-ior x#+mod4-mask+ x#+control-mask+)
          "h"
          (lambda ()
            (resize-client-rel! (current-client) 0 0 -50 0)))

(bind-key (bitwise-ior x#+mod4-mask+ x#+control-mask+)
          "j"
          (lambda ()
            (resize-client-rel! (current-client) 0 0 0 50)))

(bind-key (bitwise-ior x#+mod4-mask+ x#+control-mask+)
          "k"
          (lambda ()
            (resize-client-rel! (current-client) 0 0 0 -50)))

(bind-key (bitwise-ior x#+mod4-mask+ x#+control-mask+)
          "l"
          (lambda ()
            (resize-client-rel! (current-client) 0 0 50 0)))

(bind-key (bitwise-ior x#+mod4-mask+ x#+shift-mask+)
          "h"
          (lambda ()
            (resize-client-rel! (current-client) -50 0 0 0)))

(bind-key (bitwise-ior x#+mod4-mask+ x#+shift-mask+)
          "j"
          (lambda ()
            (resize-client-rel! (current-client) 0 50 0 0)))

(bind-key (bitwise-ior x#+mod4-mask+ x#+shift-mask+)
          "k"
          (lambda ()
            (resize-client-rel! (current-client) 0 -50 0 0)))

(bind-key (bitwise-ior x#+mod4-mask+ x#+shift-mask+)
          "l"
          (lambda ()
            (resize-client-rel! (current-client) 50 0 0 0)))

(bind-key 0 "XF86AudioRaiseVolume"
          (lambda () (shell-command "amixer set Master 2%+ &")))

(bind-key 0 "XF86AudioLowerVolume"
          (lambda () (shell-command "amixer set Master 2%- &")))

(bind-key 0 "XF86Standby" (lambda () (shell-command "sudo pm-suspend &")))

(bind-key 0 "XF86AudioMute"
          (lambda () (shell-command "amixer set Master toggle &")))
