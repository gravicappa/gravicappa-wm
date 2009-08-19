(include "~/develop/uwm/contrib/utils.scm")

(define *border-color* #x000000)
(define *selected-border-color* "#8888ff")
(define *border-width* 1)
(define *bar-height* 16)
(define *tile-ratio* 55/100)

(define *bar-font*
        "-misc-fixed-medium-r-normal-*-13-120-75-75-c-70-iso10646-1")
(define *bar-norm-bg-color* "#333333")
(define *bar-norm-color* "#bbbbbb")
(define *bar-sel-bg-color* "#444444")
(define *bar-sel-color* "white")

(define *dmenu-runner*
  (string-append "`dmenu -p 'Run:' "
                 (string<-args (dmenu-args))
                 " < ~/.programs`"))

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
(define-key *top-map* (kbd "s-u") (lambda ()
                                    (untag-client *selected* *current-view*)))
(define-key *top-map* (kbd "s-v") (lambda () (move-tag *selected*)))
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

(restart-bars)
(setenv "DMENU_ARGS" (string<-args (dmenu-args)))
