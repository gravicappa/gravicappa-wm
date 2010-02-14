(include "~/dev/uwm/sample/utils.scm")
(include "~/dev/uwm/sample/dmenu.scm")

(define *border-colour* #x000000)
(define *selected-border-colour* "#8888ff")
(define *border-width* 1)
(define *bar-height* 16)
(define *tile-ratio* 55/100)

(update-tag-status)

(add-hook *update-tag-hook* update-tag-status)

(define-global-key "s-x s-c" exit)
(define-global-key "s-x s-l" (lambda () (load *user-config-file*)))
(define-global-key "s-RET" (lambda () (shell-command& "xterm")))
(define-global-key "s-p" (lambda () (shell-command& "dmenu_run")))
(define-global-key "s-c" (lambda () (kill-client! (current-client))))
(define-global-key "s-h" focus-left)
(define-global-key "s-j" focus-before)
(define-global-key "s-k" focus-after)
(define-global-key "s-l" focus-right)
(define-global-key "s-a" focus-previous)
(define-global-key "s-o" (lambda () (zoom-client (current-client))))
(define-global-key "s-f" toggle-fullscreen)
(define-global-key "s-m" (lambda () (tag (current-client))))
(define-global-key "s-u" (lambda () (untag-client (current-client)
                                                  (current-view))))

(define-global-key "s-t"
  (lambda ()
    (view-tag (dmenu "View:" (lambda () (collect-all-tags))))))

(define-global-key "s-r" (lambda () (view-tag *prev-view*)))

(define-global-key "s-e"
  (lambda ()
    (to-run (lambda ()
              (eval-from-string
                (dmenu "Eval:" (lambda () '())))))))

(define-global-key "s-C-h"
  (lambda ()
    (resize-client-rel! (current-client) 0 0 -50 0)))

(define-global-key "s-C-j"
  (lambda ()
    (resize-client-rel! (current-client) 0 0 0 50)))

(define-global-key "s-C-k"
  (lambda ()
    (resize-client-rel! (current-client) 0 0 0 -50)))

(define-global-key "s-C-l"
  (lambda ()
    (resize-client-rel! (current-client) 0 0 50 0)))

(define-global-key "s-S-h"
  (lambda ()
    (resize-client-rel! (current-client) -50 0 0 0)))

(define-global-key "s-S-j"
  (lambda ()
    (resize-client-rel! (current-client) 0 50 0 0)))

(define-global-key "s-S-k"
  (lambda ()
    (resize-client-rel! (current-client) 0 -50 0 0)))

(define-global-key "s-S-l"
  (lambda ()
    (resize-client-rel! (current-client) 50 0 0 0)))

(define-global-key "XF86AudioRaiseVolume"
  (lambda () (shell-command& "amixer set Master 2%+")))

(define-global-key "XF86AudioLowerVolume"
  (lambda () (shell-command& "amixer set Master 2%-")))

(define-global-key "XF86Sleep"
  (lambda ()
    (shell-command& "sudo pm-suspend")))
