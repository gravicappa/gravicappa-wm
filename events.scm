;(include "xlib/Xlib#.scm")

(define-x-event map-request (window parent send-event?)
	(unless (or send-event? (client-from-window* window))
		(let ((attr (x-get-window-attributes window)))
			(unless (x-window-attribute-override-redirect? attr)
				(manage-window window (find-screen parent))))))
