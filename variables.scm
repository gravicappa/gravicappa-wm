(define *user-config-file* "~/.uwm.scm")

;;; defaults
(define *border-colour* #x070707)
(define *selected-border-colour* #xfdaf3e)
(define *border-width* 1)
(define *bar-height* 16)
(define *tile-ratio* 55/100)
(define *initial-view* "-")

(define-global-key "s-x s-c" exit)
(define-global-key "s-RET" (lambda () (shell-command "xterm&")))
(define-global-key "s-h" focus-left)
(define-global-key "s-j" focus-before)
(define-global-key "s-k" focus-after)
(define-global-key "s-l" focus-right)
(define-global-key "s-a" focus-previous)
(define-global-key "s-o" (lambda () (zoom-client (current-client))))
(define-global-key "s-c" (lambda () (kill-client! (current-client))))
