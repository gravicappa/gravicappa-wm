(include "~/develop/uwm/contrib/utils.scm")

(define *border-color* #x000000)
(define *selected-border-color* #xb0f0b7)
(define *border-width* 1)
(define *bar-height* 16)
(define *tile-ratio* 55/100)

(define *bar-font* "-*-fixed-medium-r-*-*-14-*-*-*-*-*-iso10646-1")
(define *bar-norm-bg-color* "black")
(define *bar-norm-color* "gray")
(define *bar-sel-bg-color* "#104030")
(define *bar-sel-color* "white")

(define *dmenu-runner*
  (string-append "`" (make-dmenu-command "Run:") "< ~/.programs`"))

(update-tag-status)

(add-hook *retag-hook* 'update-tag-status)

(define-key *top-map* (kbd "s-x s-c") (lambda () (exit)))
(define-key *top-map* (kbd "s-x s-l") (lambda () (load *user-config-file*)))
(define-key *top-map* (kbd "s-RET") (lambda () (shell-command& "xterm")))
(define-key *top-map* (kbd "s-p") (lambda () (shell-command& *dmenu-runner*)))
(define-key *top-map* (kbd "s-c") (lambda () (kill-client *selected*)))
(define-key *top-map* (kbd "s-h") (lambda () (focus-client 'left)))
(define-key *top-map* (kbd "s-j") (lambda () (focus-client 'down)))
(define-key *top-map* (kbd "s-k") (lambda () (focus-client 'up)))
(define-key *top-map* (kbd "s-l") (lambda () (focus-client 'right)))
(define-key *top-map* (kbd "s-a") (lambda () (focus-previous)))
(define-key *top-map* (kbd "s-o") (lambda () (zoom-client)))
(define-key *top-map* (kbd "s-TAB") (lambda () (focus-in-list 'after)))
(define-key *top-map* (kbd "s-S-TAB") (lambda () (focus-in-list 'before)))

(define-key *top-map* (kbd "s-f") (lambda () (toggle-fullscreen)))
(define-key *top-map* (kbd "s-m") (lambda () (tag *selected*)))
(define-key *top-map* (kbd "s-u") (lambda () (untag *selected*)))
(define-key *top-map* (kbd "s-t") (lambda () (view)))
(define-key *top-map* (kbd "s-r") (lambda () (view-tag *prev-view*)))

(define-key *top-map* (kbd "s-e")
            (lambda () (to-run (lambda ()
                                 (eval-from-string
                                   (dmenu "Eval:" (lambda () '())))))))

(define-key *top-map* (kbd "s-M-h")
            (lambda () (resize-client-by *selected* 0 0 -50 0)))
(define-key *top-map* (kbd "s-M-j")
            (lambda () (resize-client-by *selected* 0 0 0 50)))
(define-key *top-map* (kbd "s-M-k")
            (lambda () (resize-client-by *selected* 0 0 0 -50)))
(define-key *top-map* (kbd "s-M-l")
            (lambda () (resize-client-by *selected* 0 0 50 0)))

(define-key *top-map* (kbd "s-S-h")
            (lambda () (resize-client-by *selected* -50 0 0 0)))
(define-key *top-map* (kbd "s-S-j")
            (lambda () (resize-client-by *selected* 0 50 0 0)))
(define-key *top-map* (kbd "s-S-k")
            (lambda () (resize-client-by *selected* 0 -50 0 0)))
(define-key *top-map* (kbd "s-S-l")
            (lambda () (resize-client-by *selected* 50 0 0 0)))

(define-key *top-map* (kbd "XF86AudioRaiseVolume")
            (lambda () (shell-command& "amixer set Master 2%+")))

(define-key *top-map* (kbd "XF86AudioLowerVolume")
            (lambda () (shell-command& "amixer set Master 2%-")))

(define-key *top-map* (kbd "XF86Sleep")
            (lambda () 
              (shell-command& "sudo pm-suspend")))

(define-key *top-map* (kbd "XF86AudioMute")
            (lambda () (shell-command& "amixer set Master toggle")))

(define-key *top-map* (kbd "XF86Sleep")
            (lambda () 
              (shell-command& "sudo pm-suspend")))

(restart-bars)
