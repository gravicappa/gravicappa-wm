;; Include library where pipe-command, (un)tag, view-tag, toggle-fullscreen,
;; eval-from-string, split-string are defined.
;; Assumed that the corresponding files were copied from `sample/` directory.
(load "~/.gravicappa-wm.d/utils.scm")
(load "~/.gravicappa-wm.d/pipe-command.scm")
(load "~/.gravicappa-wm.d/dmenu.scm")

(set! border-colour #xf0f0a0)
(set! selected-border-colour #xaf0000)
(set! border-width 2)

;; 16 pixel border on top of the screen (order is left top right bottom).
(set! borders (vector 0 16 0 0))

(define (update-tag-status)
  ;; Pass all tags provided by (collect-all-tags) to some status bar
  ;; application (e.g. dzen2).
  #f)

;; After start we update status bar
(update-tag-status)

;; Update tagbar every time it changes
(define update-tag-hook update-tag-status)

;; All hooks are:
;; * shutdown-hook — is called with no arguments on exit
;; * update-tag-hook — is called with no arguments when taglist is updated.
;; * client-create-hook — is called with (client classname) arguments when
;;   new client is created before it is mapped. Automatic tagging is
;;   done here. classname is cons with x11 window class information.
;; * tag-hook — is called 

(bind-key x#+mod4-mask+ "Return" (lambda () (shell-command "xterm&")))
(bind-key x#+mod4-mask+ "h" focus-left)
(bind-key x#+mod4-mask+ "j" focus-before)
(bind-key x#+mod4-mask+ "k" focus-after)
(bind-key x#+mod4-mask+ "l" focus-right)
(bind-key x#+mod4-mask+ "a" focus-previous)
(bind-key x#+mod4-mask+ "o" (lambda () (zoom-client (current-client))))
(bind-key x#+mod4-mask+ "c" (lambda () (kill-client! (current-client))))
(bind-key x#+mod4-mask+ "p" (lambda () (shell-command "dmenu_run&")))
(bind-key x#+mod4-mask+ "f" toggle-fullscreen)
(bind-key x#+mod4-mask+ "m" (lambda () (tag (current-client))))
(bind-key x#+mod4-mask+ "u" (lambda () (untag-client (current-client)
                                                     (current-tag))))

(bind-key x#+mod4-mask+ "t" (lambda ()
                              (view-tag (dmenu "View:" (collect-all-tags)))))

(bind-key x#+mod4-mask+ "e"
          (lambda () (eval-from-string (dmenu "Eval:" '()))))

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
          (lambda () (resize-client-rel! (current-client) 50 0 0 0)))

(bind-key 0 "XF86AudioRaiseVolume"
          (lambda () (shell-command "amixer set Master 2%+ &")))

(bind-key 0 "XF86AudioLowerVolume"
          (lambda () (shell-command "amixer set Master 2%- &")))

(bind-key 0 "XF86Standby" (lambda () (shell-command "sudo pm-suspend &")))

(bind-key 0 "XF86AudioMute"
          (lambda () (shell-command "amixer set Master toggle &")))
