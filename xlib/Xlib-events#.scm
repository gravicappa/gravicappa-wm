;; XAnyEvent accessors

(define x-any-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xany.type;"))

(define x-any-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xany.type = ___arg2;"))

(define x-any-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xany.serial;"))

(define x-any-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xany.serial = ___arg2;"))

(define x-any-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xany.send_event;"))

(define x-any-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xany.send_event = ___arg2;"))

(define x-any-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xany.display;"))

(define x-any-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xany.display = ___arg2;"))

(define x-any-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xany.window;"))

(define x-any-event-window-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xany.window = ___arg2;"))

;; XKeyEvent accessors

(define x-key-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xkey.type;"))

(define x-key-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xkey.type = ___arg2;"))

(define x-key-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xkey.serial;"))

(define x-key-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xkey.serial = ___arg2;"))

(define x-key-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xkey.send_event;"))

(define x-key-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xkey.send_event = ___arg2;"))

(define x-key-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xkey.display;"))

(define x-key-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xkey.display = ___arg2;"))

(define x-key-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xkey.window;"))

(define x-key-event-window-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xkey.window = ___arg2;"))

(define x-key-event-root
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xkey.root;"))

(define x-key-event-root-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xkey.root = ___arg2;"))

(define x-key-event-subwindow
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xkey.subwindow;"))

(define x-key-event-subwindow-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xkey.subwindow = ___arg2;"))

(define x-key-event-time
  (c-lambda (XEvent*) 
            Time 
            "___result = ___arg1->xkey.time;"))

(define x-key-event-time-set!
  (c-lambda (XEvent* Time)
            void
            "___arg1->xkey.time = ___arg2;"))

(define x-key-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xkey.x;"))

(define x-key-event-x-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xkey.x = ___arg2;"))

(define x-key-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xkey.y;"))

(define x-key-event-y-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xkey.y = ___arg2;"))

(define x-key-event-x-root
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xkey.x_root;"))

(define x-key-event-x-root-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xkey.x_root = ___arg2;"))

(define x-key-event-y-root
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xkey.y_root;"))

(define x-key-event-y-root-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xkey.y_root = ___arg2;"))

(define x-key-event-state
  (c-lambda (XEvent*) 
            unsigned-int 
            "___result = ___arg1->xkey.state;"))

(define x-key-event-state-set!
  (c-lambda (XEvent* unsigned-int)
            void
            "___arg1->xkey.state = ___arg2;"))

(define x-key-event-keycode
  (c-lambda (XEvent*) 
            unsigned-int 
            "___result = ___arg1->xkey.keycode;"))

(define x-key-event-keycode-set!
  (c-lambda (XEvent* unsigned-int)
            void
            "___arg1->xkey.keycode = ___arg2;"))

(define x-key-event-same-screen?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xkey.same_screen;"))

(define x-key-event-same-screen?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xkey.same_screen = ___arg2;"))

;; XButtonEvent accessors

(define x-button-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xbutton.type;"))

(define x-button-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xbutton.type = ___arg2;"))

(define x-button-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xbutton.serial;"))

(define x-button-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xbutton.serial = ___arg2;"))

(define x-button-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xbutton.send_event;"))

(define x-button-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xbutton.send_event = ___arg2;"))

(define x-button-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xbutton.display;"))

(define x-button-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xbutton.display = ___arg2;"))

(define x-button-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xbutton.window;"))

(define x-button-event-window-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xbutton.window = ___arg2;"))

(define x-button-event-root
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xbutton.root;"))

(define x-button-event-root-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xbutton.root = ___arg2;"))

(define x-button-event-subwindow
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xbutton.subwindow;"))

(define x-button-event-subwindow-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xbutton.subwindow = ___arg2;"))

(define x-button-event-time
  (c-lambda (XEvent*) 
            Time 
            "___result = ___arg1->xbutton.time;"))

(define x-button-event-time-set!
  (c-lambda (XEvent* Time)
            void
            "___arg1->xbutton.time = ___arg2;"))

(define x-button-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xbutton.x;"))

(define x-button-event-x-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xbutton.x = ___arg2;"))

(define x-button-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xbutton.y;"))

(define x-button-event-y-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xbutton.y = ___arg2;"))

(define x-button-event-x-root
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xbutton.x_root;"))

(define x-button-event-x-root-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xbutton.x_root = ___arg2;"))

(define x-button-event-y-root
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xbutton.y_root;"))

(define x-button-event-y-root-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xbutton.y_root = ___arg2;"))

(define x-button-event-state
  (c-lambda (XEvent*) 
            unsigned-int 
            "___result = ___arg1->xbutton.state;"))

(define x-button-event-state-set!
  (c-lambda (XEvent* unsigned-int)
            void
            "___arg1->xbutton.state = ___arg2;"))

(define x-button-event-button
  (c-lambda (XEvent*) 
            unsigned-int 
            "___result = ___arg1->xbutton.button;"))

(define x-button-event-button-set!
  (c-lambda (XEvent* unsigned-int)
            void
            "___arg1->xbutton.button = ___arg2;"))

(define x-button-event-same-screen?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xbutton.same_screen;"))

(define x-button-event-same-screen?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xbutton.same_screen = ___arg2;"))

;; XMotionEvent accessors

(define x-motion-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xmotion.type;"))

(define x-motion-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xmotion.type = ___arg2;"))

(define x-motion-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xmotion.serial;"))

(define x-motion-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xmotion.serial = ___arg2;"))

(define x-motion-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xmotion.send_event;"))

(define x-motion-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xmotion.send_event = ___arg2;"))

(define x-motion-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xmotion.display;"))

(define x-motion-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xmotion.display = ___arg2;"))

(define x-motion-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xmotion.window;"))

(define x-motion-event-window-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xmotion.window = ___arg2;"))

(define x-motion-event-root
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xmotion.root;"))

(define x-motion-event-root-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xmotion.root = ___arg2;"))

(define x-motion-event-subwindow
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xmotion.subwindow;"))

(define x-motion-event-subwindow-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xmotion.subwindow = ___arg2;"))

(define x-motion-event-time
  (c-lambda (XEvent*) 
            Time 
            "___result = ___arg1->xmotion.time;"))

(define x-motion-event-time-set!
  (c-lambda (XEvent* Time)
            void
            "___arg1->xmotion.time = ___arg2;"))

(define x-motion-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xmotion.x;"))

(define x-motion-event-x-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xmotion.x = ___arg2;"))

(define x-motion-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xmotion.y;"))

(define x-motion-event-y-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xmotion.y = ___arg2;"))

(define x-motion-event-x-root
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xmotion.x_root;"))

(define x-motion-event-x-root-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xmotion.x_root = ___arg2;"))

(define x-motion-event-y-root
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xmotion.y_root;"))

(define x-motion-event-y-root-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xmotion.y_root = ___arg2;"))

(define x-motion-event-state
  (c-lambda (XEvent*) 
            unsigned-int 
            "___result = ___arg1->xmotion.state;"))

(define x-motion-event-state-set!
  (c-lambda (XEvent* unsigned-int)
            void
            "___arg1->xmotion.state = ___arg2;"))

(define x-motion-event-is-hint
  (c-lambda (XEvent*) 
            char 
            "___result = ___arg1->xmotion.is_hint;"))

(define x-motion-event-is-hint-set!
  (c-lambda (XEvent* char)
            void
            "___arg1->xmotion.is_hint = ___arg2;"))

(define x-motion-event-same-screen?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xmotion.same_screen;"))

(define x-motion-event-same-screen?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xmotion.same_screen = ___arg2;"))

;; XCrossingEvent accessors

(define x-crossing-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcrossing.type;"))

(define x-crossing-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcrossing.type = ___arg2;"))

(define x-crossing-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xcrossing.serial;"))

(define x-crossing-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xcrossing.serial = ___arg2;"))

(define x-crossing-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xcrossing.send_event;"))

(define x-crossing-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xcrossing.send_event = ___arg2;"))

(define x-crossing-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xcrossing.display;"))

(define x-crossing-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xcrossing.display = ___arg2;"))

(define x-crossing-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xcrossing.window;"))

(define x-crossing-event-window-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xcrossing.window = ___arg2;"))

(define x-crossing-event-root
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xcrossing.root;"))

(define x-crossing-event-root-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xcrossing.root = ___arg2;"))

(define x-crossing-event-subwindow
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xcrossing.subwindow;"))

(define x-crossing-event-subwindow-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xcrossing.subwindow = ___arg2;"))

(define x-crossing-event-time
  (c-lambda (XEvent*) 
            Time 
            "___result = ___arg1->xcrossing.time;"))

(define x-crossing-event-time-set!
  (c-lambda (XEvent* Time)
            void
            "___arg1->xcrossing.time = ___arg2;"))

(define x-crossing-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcrossing.x;"))

(define x-crossing-event-x-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcrossing.x = ___arg2;"))

(define x-crossing-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcrossing.y;"))

(define x-crossing-event-y-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcrossing.y = ___arg2;"))

(define x-crossing-event-x-root
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcrossing.x_root;"))

(define x-crossing-event-x-root-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcrossing.x_root = ___arg2;"))

(define x-crossing-event-y-root
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcrossing.y_root;"))

(define x-crossing-event-y-root-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcrossing.y_root = ___arg2;"))

(define x-crossing-event-mode
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcrossing.mode;"))

(define x-crossing-event-mode-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcrossing.mode = ___arg2;"))

(define x-crossing-event-detail
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcrossing.detail;"))

(define x-crossing-event-detail-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcrossing.detail = ___arg2;"))

(define x-crossing-event-same-screen?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xcrossing.same_screen;"))

(define x-crossing-event-same-screen?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xcrossing.same_screen = ___arg2;"))

(define x-crossing-event-focus?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xcrossing.focus;"))

(define x-crossing-event-focus?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xcrossing.focus = ___arg2;"))

(define x-crossing-event-state
  (c-lambda (XEvent*) 
            unsigned-int 
            "___result = ___arg1->xcrossing.state;"))

(define x-crossing-event-state-set!
  (c-lambda (XEvent* unsigned-int)
            void
            "___arg1->xcrossing.state = ___arg2;"))

;; XFocusChangeEvent accessors

(define x-focus-change-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xfocus.type;"))

(define x-focus-change-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xfocus.type = ___arg2;"))

(define x-focus-change-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xfocus.serial;"))

(define x-focus-change-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xfocus.serial = ___arg2;"))

(define x-focus-change-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xfocus.send_event;"))

(define x-focus-change-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xfocus.send_event = ___arg2;"))

(define x-focus-change-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xfocus.display;"))

(define x-focus-change-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xfocus.display = ___arg2;"))

(define x-focus-change-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xfocus.window;"))

(define x-focus-change-event-window-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xfocus.window = ___arg2;"))

(define x-focus-change-event-mode
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xfocus.mode;"))

(define x-focus-change-event-mode-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xfocus.mode = ___arg2;"))

(define x-focus-change-event-detail
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xfocus.detail;"))

(define x-focus-change-event-detail-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xfocus.detail = ___arg2;"))

;; XKeymapEvent accessors

(define x-keymap-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xkeymap.type;"))

(define x-keymap-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xkeymap.type = ___arg2;"))

(define x-keymap-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xkeymap.serial;"))

(define x-keymap-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xkeymap.serial = ___arg2;"))

(define x-keymap-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xkeymap.send_event;"))

(define x-keymap-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xkeymap.send_event = ___arg2;"))

(define x-keymap-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xkeymap.display;"))

(define x-keymap-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xkeymap.display = ___arg2;"))

(define x-keymap-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xkeymap.window;"))

(define x-keymap-event-window-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xkeymap.window = ___arg2;"))

;; XExposeEvent accessors

(define x-expose-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xexpose.type;"))

(define x-expose-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xexpose.type = ___arg2;"))

(define x-expose-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xexpose.serial;"))

(define x-expose-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xexpose.serial = ___arg2;"))

(define x-expose-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xexpose.send_event;"))

(define x-expose-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xexpose.send_event = ___arg2;"))

(define x-expose-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xexpose.display;"))

(define x-expose-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xexpose.display = ___arg2;"))

(define x-expose-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xexpose.window;"))

(define x-expose-event-window-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xexpose.window = ___arg2;"))

(define x-expose-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xexpose.x;"))

(define x-expose-event-x-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xexpose.x = ___arg2;"))

(define x-expose-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xexpose.y;"))

(define x-expose-event-y-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xexpose.y = ___arg2;"))

(define x-expose-event-width
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xexpose.width;"))

(define x-expose-event-width-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xexpose.width = ___arg2;"))

(define x-expose-event-height
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xexpose.height;"))

(define x-expose-event-height-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xexpose.height = ___arg2;"))

(define x-expose-event-count
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xexpose.count;"))

(define x-expose-event-count-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xexpose.count = ___arg2;"))

;; XGraphicsExposeEvent accessors

(define x-graphics-expose-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgraphicsexpose.type;"))

(define x-graphics-expose-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xgraphicsexpose.type = ___arg2;"))

(define x-graphics-expose-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xgraphicsexpose.serial;"))

(define x-graphics-expose-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xgraphicsexpose.serial = ___arg2;"))

(define x-graphics-expose-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xgraphicsexpose.send_event;"))

(define x-graphics-expose-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xgraphicsexpose.send_event = ___arg2;"))

(define x-graphics-expose-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xgraphicsexpose.display;"))

(define x-graphics-expose-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xgraphicsexpose.display = ___arg2;"))

(define x-graphics-expose-event-drawable
  (c-lambda (XEvent*) 
            Drawable 
            "___result = ___arg1->xgraphicsexpose.drawable;"))

(define x-graphics-expose-event-drawable-set!
  (c-lambda (XEvent* Drawable)
            void
            "___arg1->xgraphicsexpose.drawable = ___arg2;"))

(define x-graphics-expose-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgraphicsexpose.x;"))

(define x-graphics-expose-event-x-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xgraphicsexpose.x = ___arg2;"))

(define x-graphics-expose-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgraphicsexpose.y;"))

(define x-graphics-expose-event-y-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xgraphicsexpose.y = ___arg2;"))

(define x-graphics-expose-event-width
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgraphicsexpose.width;"))

(define x-graphics-expose-event-width-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xgraphicsexpose.width = ___arg2;"))

(define x-graphics-expose-event-height
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgraphicsexpose.height;"))

(define x-graphics-expose-event-height-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xgraphicsexpose.height = ___arg2;"))

(define x-graphics-expose-event-count
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgraphicsexpose.count;"))

(define x-graphics-expose-event-count-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xgraphicsexpose.count = ___arg2;"))

(define x-graphics-expose-event-major-code
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgraphicsexpose.major_code;"))

(define x-graphics-expose-event-major-code-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xgraphicsexpose.major_code = ___arg2;"))

(define x-graphics-expose-event-minor-code
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgraphicsexpose.minor_code;"))

(define x-graphics-expose-event-minor-code-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xgraphicsexpose.minor_code = ___arg2;"))

;; XNoExposeEvent accessors

(define x-no-expose-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xnoexpose.type;"))

(define x-no-expose-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xnoexpose.type = ___arg2;"))

(define x-no-expose-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xnoexpose.serial;"))

(define x-no-expose-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xnoexpose.serial = ___arg2;"))

(define x-no-expose-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xnoexpose.send_event;"))

(define x-no-expose-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xnoexpose.send_event = ___arg2;"))

(define x-no-expose-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xnoexpose.display;"))

(define x-no-expose-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xnoexpose.display = ___arg2;"))

(define x-no-expose-event-drawable
  (c-lambda (XEvent*) 
            Drawable 
            "___result = ___arg1->xnoexpose.drawable;"))

(define x-no-expose-event-drawable-set!
  (c-lambda (XEvent* Drawable)
            void
            "___arg1->xnoexpose.drawable = ___arg2;"))

(define x-no-expose-event-major-code
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xnoexpose.major_code;"))

(define x-no-expose-event-major-code-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xnoexpose.major_code = ___arg2;"))

(define x-no-expose-event-minor-code
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xnoexpose.minor_code;"))

(define x-no-expose-event-minor-code-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xnoexpose.minor_code = ___arg2;"))

;; XVisibilityEvent accessors

(define x-visibility-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xvisibility.type;"))

(define x-visibility-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xvisibility.type = ___arg2;"))

(define x-visibility-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xvisibility.serial;"))

(define x-visibility-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xvisibility.serial = ___arg2;"))

(define x-visibility-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xvisibility.send_event;"))

(define x-visibility-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xvisibility.send_event = ___arg2;"))

(define x-visibility-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xvisibility.display;"))

(define x-visibility-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xvisibility.display = ___arg2;"))

(define x-visibility-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xvisibility.window;"))

(define x-visibility-event-window-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xvisibility.window = ___arg2;"))

(define x-visibility-event-state
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xvisibility.state;"))

(define x-visibility-event-state-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xvisibility.state = ___arg2;"))

;; XCreateWindowEvent accessors

(define x-create-window-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcreatewindow.type;"))

(define x-create-window-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcreatewindow.type = ___arg2;"))

(define x-create-window-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xcreatewindow.serial;"))

(define x-create-window-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xcreatewindow.serial = ___arg2;"))

(define x-create-window-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xcreatewindow.send_event;"))

(define x-create-window-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xcreatewindow.send_event = ___arg2;"))

(define x-create-window-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xcreatewindow.display;"))

(define x-create-window-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xcreatewindow.display = ___arg2;"))

(define x-create-window-event-parent
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xcreatewindow.parent;"))

(define x-create-window-event-parent-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xcreatewindow.parent = ___arg2;"))

(define x-create-window-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xcreatewindow.window;"))

(define x-create-window-event-window-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xcreatewindow.window = ___arg2;"))

(define x-create-window-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcreatewindow.x;"))

(define x-create-window-event-x-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcreatewindow.x = ___arg2;"))

(define x-create-window-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcreatewindow.y;"))

(define x-create-window-event-y-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcreatewindow.y = ___arg2;"))

(define x-create-window-event-width
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcreatewindow.width;"))

(define x-create-window-event-width-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcreatewindow.width = ___arg2;"))

(define x-create-window-event-height
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcreatewindow.height;"))

(define x-create-window-event-height-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcreatewindow.height = ___arg2;"))

(define x-create-window-event-border-width
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcreatewindow.border_width;"))

(define x-create-window-event-border-width-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcreatewindow.border_width = ___arg2;"))

(define x-create-window-event-override-redirect?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xcreatewindow.override_redirect;"))

(define x-create-window-event-override-redirect?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xcreatewindow.override_redirect = ___arg2;"))

;; XDestroyWindowEvent accessors

(define x-destroy-window-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xdestroywindow.type;"))

(define x-destroy-window-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xdestroywindow.type = ___arg2;"))

(define x-destroy-window-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xdestroywindow.serial;"))

(define x-destroy-window-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xdestroywindow.serial = ___arg2;"))

(define x-destroy-window-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xdestroywindow.send_event;"))

(define x-destroy-window-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xdestroywindow.send_event = ___arg2;"))

(define x-destroy-window-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xdestroywindow.display;"))

(define x-destroy-window-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xdestroywindow.display = ___arg2;"))

(define x-destroy-window-event-event
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xdestroywindow.event;"))

(define x-destroy-window-event-event-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xdestroywindow.event = ___arg2;"))

(define x-destroy-window-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xdestroywindow.window;"))

(define x-destroy-window-event-window-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xdestroywindow.window = ___arg2;"))

;; XUnmapEvent accessors

(define x-unmap-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xunmap.type;"))

(define x-unmap-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xunmap.type = ___arg2;"))

(define x-unmap-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xunmap.serial;"))

(define x-unmap-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xunmap.serial = ___arg2;"))

(define x-unmap-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xunmap.send_event;"))

(define x-unmap-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xunmap.send_event = ___arg2;"))

(define x-unmap-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xunmap.display;"))

(define x-unmap-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xunmap.display = ___arg2;"))

(define x-unmap-event-event
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xunmap.event;"))

(define x-unmap-event-event-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xunmap.event = ___arg2;"))

(define x-unmap-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xunmap.window;"))

(define x-unmap-event-window-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xunmap.window = ___arg2;"))

(define x-unmap-event-from-configure?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xunmap.from_configure;"))

(define x-unmap-event-from-configure?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xunmap.from_configure = ___arg2;"))

;; XMapEvent accessors

(define x-map-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xmap.type;"))

(define x-map-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xmap.type = ___arg2;"))

(define x-map-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xmap.serial;"))

(define x-map-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xmap.serial = ___arg2;"))

(define x-map-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xmap.send_event;"))

(define x-map-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xmap.send_event = ___arg2;"))

(define x-map-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xmap.display;"))

(define x-map-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xmap.display = ___arg2;"))

(define x-map-event-event
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xmap.event;"))

(define x-map-event-event-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xmap.event = ___arg2;"))

(define x-map-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xmap.window;"))

(define x-map-event-window-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xmap.window = ___arg2;"))

(define x-map-event-override-redirect?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xmap.override_redirect;"))

(define x-map-event-override-redirect?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xmap.override_redirect = ___arg2;"))

;; XMapRequestEvent accessors

(define x-map-request-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xmaprequest.type;"))

(define x-map-request-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xmaprequest.type = ___arg2;"))

(define x-map-request-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xmaprequest.serial;"))

(define x-map-request-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xmaprequest.serial = ___arg2;"))

(define x-map-request-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xmaprequest.send_event;"))

(define x-map-request-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xmaprequest.send_event = ___arg2;"))

(define x-map-request-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xmaprequest.display;"))

(define x-map-request-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xmaprequest.display = ___arg2;"))

(define x-map-request-event-parent
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xmaprequest.parent;"))

(define x-map-request-event-parent-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xmaprequest.parent = ___arg2;"))

(define x-map-request-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xmaprequest.window;"))

(define x-map-request-event-window-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xmaprequest.window = ___arg2;"))

;; XReparentEvent accessors

(define x-reparent-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xreparent.type;"))

(define x-reparent-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xreparent.type = ___arg2;"))

(define x-reparent-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xreparent.serial;"))

(define x-reparent-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xreparent.serial = ___arg2;"))

(define x-reparent-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xreparent.send_event;"))

(define x-reparent-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xreparent.send_event = ___arg2;"))

(define x-reparent-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xreparent.display;"))

(define x-reparent-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xreparent.display = ___arg2;"))

(define x-reparent-event-event
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xreparent.event;"))

(define x-reparent-event-event-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xreparent.event = ___arg2;"))

(define x-reparent-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xreparent.window;"))

(define x-reparent-event-window-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xreparent.window = ___arg2;"))

(define x-reparent-event-parent
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xreparent.parent;"))

(define x-reparent-event-parent-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xreparent.parent = ___arg2;"))

(define x-reparent-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xreparent.x;"))

(define x-reparent-event-x-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xreparent.x = ___arg2;"))

(define x-reparent-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xreparent.y;"))

(define x-reparent-event-y-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xreparent.y = ___arg2;"))

(define x-reparent-event-override-redirect?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xreparent.override_redirect;"))

(define x-reparent-event-override-redirect?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xreparent.override_redirect = ___arg2;"))

;; XConfigureEvent accessors

(define x-configure-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigure.type;"))

(define x-configure-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xconfigure.type = ___arg2;"))

(define x-configure-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xconfigure.serial;"))

(define x-configure-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xconfigure.serial = ___arg2;"))

(define x-configure-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xconfigure.send_event;"))

(define x-configure-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xconfigure.send_event = ___arg2;"))

(define x-configure-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xconfigure.display;"))

(define x-configure-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xconfigure.display = ___arg2;"))

(define x-configure-event-event
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xconfigure.event;"))

(define x-configure-event-event-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xconfigure.event = ___arg2;"))

(define x-configure-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xconfigure.window;"))

(define x-configure-event-window-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xconfigure.window = ___arg2;"))

(define x-configure-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigure.x;"))

(define x-configure-event-x-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xconfigure.x = ___arg2;"))

(define x-configure-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigure.y;"))

(define x-configure-event-y-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xconfigure.y = ___arg2;"))

(define x-configure-event-width
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigure.width;"))

(define x-configure-event-width-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xconfigure.width = ___arg2;"))

(define x-configure-event-height
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigure.height;"))

(define x-configure-event-height-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xconfigure.height = ___arg2;"))

(define x-configure-event-border-width
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigure.border_width;"))

(define x-configure-event-border-width-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xconfigure.border_width = ___arg2;"))

(define x-configure-event-above
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xconfigure.above;"))

(define x-configure-event-above-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xconfigure.above = ___arg2;"))

(define x-configure-event-override-redirect?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xconfigure.override_redirect;"))

(define x-configure-event-override-redirect?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xconfigure.override_redirect = ___arg2;"))

;; XGravityEvent accessors

(define x-gravity-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgravity.type;"))

(define x-gravity-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xgravity.type = ___arg2;"))

(define x-gravity-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xgravity.serial;"))

(define x-gravity-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xgravity.serial = ___arg2;"))

(define x-gravity-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xgravity.send_event;"))

(define x-gravity-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xgravity.send_event = ___arg2;"))

(define x-gravity-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xgravity.display;"))

(define x-gravity-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xgravity.display = ___arg2;"))

(define x-gravity-event-event
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xgravity.event;"))

(define x-gravity-event-event-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xgravity.event = ___arg2;"))

(define x-gravity-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xgravity.window;"))

(define x-gravity-event-window-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xgravity.window = ___arg2;"))

(define x-gravity-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgravity.x;"))

(define x-gravity-event-x-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xgravity.x = ___arg2;"))

(define x-gravity-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgravity.y;"))

(define x-gravity-event-y-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xgravity.y = ___arg2;"))

;; XResizeRequestEvent accessors

(define x-resize-request-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xresizerequest.type;"))

(define x-resize-request-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xresizerequest.type = ___arg2;"))

(define x-resize-request-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xresizerequest.serial;"))

(define x-resize-request-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xresizerequest.serial = ___arg2;"))

(define x-resize-request-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xresizerequest.send_event;"))

(define x-resize-request-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xresizerequest.send_event = ___arg2;"))

(define x-resize-request-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xresizerequest.display;"))

(define x-resize-request-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xresizerequest.display = ___arg2;"))

(define x-resize-request-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xresizerequest.window;"))

(define x-resize-request-event-window-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xresizerequest.window = ___arg2;"))

(define x-resize-request-event-width
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xresizerequest.width;"))

(define x-resize-request-event-width-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xresizerequest.width = ___arg2;"))

(define x-resize-request-event-height
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xresizerequest.height;"))

(define x-resize-request-event-height-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xresizerequest.height = ___arg2;"))

;; XConfigureRequestEvent accessors

(define x-configure-request-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigurerequest.type;"))

(define x-configure-request-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xconfigurerequest.type = ___arg2;"))

(define x-configure-request-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xconfigurerequest.serial;"))

(define x-configure-request-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xconfigurerequest.serial = ___arg2;"))

(define x-configure-request-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xconfigurerequest.send_event;"))

(define x-configure-request-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xconfigurerequest.send_event = ___arg2;"))

(define x-configure-request-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xconfigurerequest.display;"))

(define x-configure-request-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xconfigurerequest.display = ___arg2;"))

(define x-configure-request-event-parent
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xconfigurerequest.parent;"))

(define x-configure-request-event-parent-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xconfigurerequest.parent = ___arg2;"))

(define x-configure-request-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xconfigurerequest.window;"))

(define x-configure-request-event-window-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xconfigurerequest.window = ___arg2;"))

(define x-configure-request-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigurerequest.x;"))

(define x-configure-request-event-x-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xconfigurerequest.x = ___arg2;"))

(define x-configure-request-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigurerequest.y;"))

(define x-configure-request-event-y-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xconfigurerequest.y = ___arg2;"))

(define x-configure-request-event-width
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigurerequest.width;"))

(define x-configure-request-event-width-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xconfigurerequest.width = ___arg2;"))

(define x-configure-request-event-height
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigurerequest.height;"))

(define x-configure-request-event-height-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xconfigurerequest.height = ___arg2;"))

(define x-configure-request-event-border-width
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigurerequest.border_width;"))

(define x-configure-request-event-border-width-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xconfigurerequest.border_width = ___arg2;"))

(define x-configure-request-event-above
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xconfigurerequest.above;"))

(define x-configure-request-event-above-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xconfigurerequest.above = ___arg2;"))

(define x-configure-request-event-detail
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigurerequest.detail;"))

(define x-configure-request-event-detail-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xconfigurerequest.detail = ___arg2;"))

(define x-configure-request-event-value-mask
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xconfigurerequest.value_mask;"))

(define x-configure-request-event-value-mask-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xconfigurerequest.value_mask = ___arg2;"))

;; XCirculateEvent accessors

(define x-circulate-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcirculate.type;"))

(define x-circulate-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcirculate.type = ___arg2;"))

(define x-circulate-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xcirculate.serial;"))

(define x-circulate-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xcirculate.serial = ___arg2;"))

(define x-circulate-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xcirculate.send_event;"))

(define x-circulate-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xcirculate.send_event = ___arg2;"))

(define x-circulate-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xcirculate.display;"))

(define x-circulate-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xcirculate.display = ___arg2;"))

(define x-circulate-event-event
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xcirculate.event;"))

(define x-circulate-event-event-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xcirculate.event = ___arg2;"))

(define x-circulate-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xcirculate.window;"))

(define x-circulate-event-window-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xcirculate.window = ___arg2;"))

(define x-circulate-event-place
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcirculate.place;"))

(define x-circulate-event-place-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcirculate.place = ___arg2;"))

;; XCirculateRequestEvent accessors

(define x-circulate-request-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcirculaterequest.type;"))

(define x-circulate-request-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcirculaterequest.type = ___arg2;"))

(define x-circulate-request-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xcirculaterequest.serial;"))

(define x-circulate-request-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xcirculaterequest.serial = ___arg2;"))

(define x-circulate-request-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xcirculaterequest.send_event;"))

(define x-circulate-request-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xcirculaterequest.send_event = ___arg2;"))

(define x-circulate-request-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xcirculaterequest.display;"))

(define x-circulate-request-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xcirculaterequest.display = ___arg2;"))

(define x-circulate-request-event-parent
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xcirculaterequest.parent;"))

(define x-circulate-request-event-parent-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xcirculaterequest.parent = ___arg2;"))

(define x-circulate-request-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xcirculaterequest.window;"))

(define x-circulate-request-event-window-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xcirculaterequest.window = ___arg2;"))

(define x-circulate-request-event-place
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcirculaterequest.place;"))

(define x-circulate-request-event-place-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcirculaterequest.place = ___arg2;"))

;; XPropertyEvent accessors

(define x-property-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xproperty.type;"))

(define x-property-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xproperty.type = ___arg2;"))

(define x-property-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xproperty.serial;"))

(define x-property-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xproperty.serial = ___arg2;"))

(define x-property-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xproperty.send_event;"))

(define x-property-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xproperty.send_event = ___arg2;"))

(define x-property-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xproperty.display;"))

(define x-property-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xproperty.display = ___arg2;"))

(define x-property-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xproperty.window;"))

(define x-property-event-window-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xproperty.window = ___arg2;"))

(define x-property-event-atom
  (c-lambda (XEvent*) 
            Atom 
            "___result = ___arg1->xproperty.atom;"))

(define x-property-event-atom-set!
  (c-lambda (XEvent* Atom)
            void
            "___arg1->xproperty.atom = ___arg2;"))

(define x-property-event-time
  (c-lambda (XEvent*) 
            Time 
            "___result = ___arg1->xproperty.time;"))

(define x-property-event-time-set!
  (c-lambda (XEvent* Time)
            void
            "___arg1->xproperty.time = ___arg2;"))

(define x-property-event-state
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xproperty.state;"))

(define x-property-event-state-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xproperty.state = ___arg2;"))

;; XSelectionClearEvent accessors

(define x-selection-clear-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xselectionclear.type;"))

(define x-selection-clear-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xselectionclear.type = ___arg2;"))

(define x-selection-clear-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xselectionclear.serial;"))

(define x-selection-clear-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xselectionclear.serial = ___arg2;"))

(define x-selection-clear-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xselectionclear.send_event;"))

(define x-selection-clear-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xselectionclear.send_event = ___arg2;"))

(define x-selection-clear-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xselectionclear.display;"))

(define x-selection-clear-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xselectionclear.display = ___arg2;"))

(define x-selection-clear-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xselectionclear.window;"))

(define x-selection-clear-event-window-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xselectionclear.window = ___arg2;"))

(define x-selection-clear-event-selection
  (c-lambda (XEvent*) 
            Atom 
            "___result = ___arg1->xselectionclear.selection;"))

(define x-selection-clear-event-selection-set!
  (c-lambda (XEvent* Atom)
            void
            "___arg1->xselectionclear.selection = ___arg2;"))

(define x-selection-clear-event-time
  (c-lambda (XEvent*) 
            Time 
            "___result = ___arg1->xselectionclear.time;"))

(define x-selection-clear-event-time-set!
  (c-lambda (XEvent* Time)
            void
            "___arg1->xselectionclear.time = ___arg2;"))

;; XSelectionRequestEvent accessors

(define x-selection-request-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xselectionrequest.type;"))

(define x-selection-request-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xselectionrequest.type = ___arg2;"))

(define x-selection-request-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xselectionrequest.serial;"))

(define x-selection-request-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xselectionrequest.serial = ___arg2;"))

(define x-selection-request-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xselectionrequest.send_event;"))

(define x-selection-request-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xselectionrequest.send_event = ___arg2;"))

(define x-selection-request-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xselectionrequest.display;"))

(define x-selection-request-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xselectionrequest.display = ___arg2;"))

(define x-selection-request-event-owner
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xselectionrequest.owner;"))

(define x-selection-request-event-owner-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xselectionrequest.owner = ___arg2;"))

(define x-selection-request-event-requestor
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xselectionrequest.requestor;"))

(define x-selection-request-event-requestor-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xselectionrequest.requestor = ___arg2;"))

(define x-selection-request-event-selection
  (c-lambda (XEvent*) 
            Atom 
            "___result = ___arg1->xselectionrequest.selection;"))

(define x-selection-request-event-selection-set!
  (c-lambda (XEvent* Atom)
            void
            "___arg1->xselectionrequest.selection = ___arg2;"))

(define x-selection-request-event-target
  (c-lambda (XEvent*) 
            Atom 
            "___result = ___arg1->xselectionrequest.target;"))

(define x-selection-request-event-target-set!
  (c-lambda (XEvent* Atom)
            void
            "___arg1->xselectionrequest.target = ___arg2;"))

(define x-selection-request-event-property
  (c-lambda (XEvent*) 
            Atom 
            "___result = ___arg1->xselectionrequest.property;"))

(define x-selection-request-event-property-set!
  (c-lambda (XEvent* Atom)
            void
            "___arg1->xselectionrequest.property = ___arg2;"))

(define x-selection-request-event-time
  (c-lambda (XEvent*) 
            Time 
            "___result = ___arg1->xselectionrequest.time;"))

(define x-selection-request-event-time-set!
  (c-lambda (XEvent* Time)
            void
            "___arg1->xselectionrequest.time = ___arg2;"))

;; XSelectionEvent accessors

(define x-selection-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xselection.type;"))

(define x-selection-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xselection.type = ___arg2;"))

(define x-selection-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xselection.serial;"))

(define x-selection-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xselection.serial = ___arg2;"))

(define x-selection-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xselection.send_event;"))

(define x-selection-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xselection.send_event = ___arg2;"))

(define x-selection-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xselection.display;"))

(define x-selection-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xselection.display = ___arg2;"))

(define x-selection-event-requestor
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xselection.requestor;"))

(define x-selection-event-requestor-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xselection.requestor = ___arg2;"))

(define x-selection-event-selection
  (c-lambda (XEvent*) 
            Atom 
            "___result = ___arg1->xselection.selection;"))

(define x-selection-event-selection-set!
  (c-lambda (XEvent* Atom)
            void
            "___arg1->xselection.selection = ___arg2;"))

(define x-selection-event-target
  (c-lambda (XEvent*) 
            Atom 
            "___result = ___arg1->xselection.target;"))

(define x-selection-event-target-set!
  (c-lambda (XEvent* Atom)
            void
            "___arg1->xselection.target = ___arg2;"))

(define x-selection-event-property
  (c-lambda (XEvent*) 
            Atom 
            "___result = ___arg1->xselection.property;"))

(define x-selection-event-property-set!
  (c-lambda (XEvent* Atom)
            void
            "___arg1->xselection.property = ___arg2;"))

(define x-selection-event-time
  (c-lambda (XEvent*) 
            Time 
            "___result = ___arg1->xselection.time;"))

(define x-selection-event-time-set!
  (c-lambda (XEvent* Time)
            void
            "___arg1->xselection.time = ___arg2;"))

;; XColormapEvent accessors

(define x-colormap-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcolormap.type;"))

(define x-colormap-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcolormap.type = ___arg2;"))

(define x-colormap-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xcolormap.serial;"))

(define x-colormap-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xcolormap.serial = ___arg2;"))

(define x-colormap-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xcolormap.send_event;"))

(define x-colormap-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xcolormap.send_event = ___arg2;"))

(define x-colormap-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xcolormap.display;"))

(define x-colormap-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xcolormap.display = ___arg2;"))

(define x-colormap-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xcolormap.window;"))

(define x-colormap-event-window-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xcolormap.window = ___arg2;"))

(define x-colormap-event-colormap
  (c-lambda (XEvent*) 
            Colormap 
            "___result = ___arg1->xcolormap.colormap;"))

(define x-colormap-event-colormap-set!
  (c-lambda (XEvent* Colormap)
            void
            "___arg1->xcolormap.colormap = ___arg2;"))

(define x-colormap-event-new?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xcolormap.new;"))

(define x-colormap-event-new?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xcolormap.new = ___arg2;"))

(define x-colormap-event-state
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcolormap.state;"))

(define x-colormap-event-state-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcolormap.state = ___arg2;"))

;; XClientMessageEvent accessors

(define x-client-message-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xclient.type;"))

(define x-client-message-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xclient.type = ___arg2;"))

(define x-client-message-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xclient.serial;"))

(define x-client-message-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xclient.serial = ___arg2;"))

(define x-client-message-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xclient.send_event;"))

(define x-client-message-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xclient.send_event = ___arg2;"))

(define x-client-message-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xclient.display;"))

(define x-client-message-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xclient.display = ___arg2;"))

(define x-client-message-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xclient.window;"))

(define x-client-message-event-window-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xclient.window = ___arg2;"))

(define x-client-message-event-message-type
  (c-lambda (XEvent*) 
            Atom 
            "___result = ___arg1->xclient.message_type;"))

(define x-client-message-event-message-type-set!
  (c-lambda (XEvent* Atom)
            void
            "___arg1->xclient.message_type = ___arg2;"))

(define x-client-message-event-format
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xclient.format;"))

(define x-client-message-event-format-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xclient.format = ___arg2;"))

;; XMappingEvent accessors

(define x-mapping-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xmapping.type;"))

(define x-mapping-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xmapping.type = ___arg2;"))

(define x-mapping-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xmapping.serial;"))

(define x-mapping-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xmapping.serial = ___arg2;"))

(define x-mapping-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xmapping.send_event;"))

(define x-mapping-event-send-event?-set!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xmapping.send_event = ___arg2;"))

(define x-mapping-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xmapping.display;"))

(define x-mapping-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xmapping.display = ___arg2;"))

(define x-mapping-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xmapping.window;"))

(define x-mapping-event-window-set!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xmapping.window = ___arg2;"))

(define x-mapping-event-request
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xmapping.request;"))

(define x-mapping-event-request-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xmapping.request = ___arg2;"))

(define x-mapping-event-first-keycode
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xmapping.first_keycode;"))

(define x-mapping-event-first-keycode-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xmapping.first_keycode = ___arg2;"))

(define x-mapping-event-count
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xmapping.count;"))

(define x-mapping-event-count-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xmapping.count = ___arg2;"))

;; XErrorEvent accessors

(define x-error-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xerror.type;"))

(define x-error-event-type-set!
  (c-lambda (XEvent* int)
            void
            "___arg1->xerror.type = ___arg2;"))

(define x-error-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xerror.display;"))

(define x-error-event-display-set!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xerror.display = ___arg2;"))

(define x-error-event-resourceid
  (c-lambda (XEvent*) 
            XID 
            "___result = ___arg1->xerror.resourceid;"))

(define x-error-event-resourceid-set!
  (c-lambda (XEvent* XID)
            void
            "___arg1->xerror.resourceid = ___arg2;"))

(define x-error-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xerror.serial;"))

(define x-error-event-serial-set!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xerror.serial = ___arg2;"))

(define x-error-event-error-code
  (c-lambda (XEvent*) 
            unsigned-char 
            "___result = ___arg1->xerror.error_code;"))

(define x-error-event-error-code-set!
  (c-lambda (XEvent* unsigned-char)
            void
            "___arg1->xerror.error_code = ___arg2;"))

(define x-error-event-request-code
  (c-lambda (XEvent*) 
            unsigned-char 
            "___result = ___arg1->xerror.request_code;"))

(define x-error-event-request-code-set!
  (c-lambda (XEvent* unsigned-char)
            void
            "___arg1->xerror.request_code = ___arg2;"))

(define x-error-event-minor-code
  (c-lambda (XEvent*) 
            unsigned-char 
            "___result = ___arg1->xerror.minor_code;"))

(define x-error-event-minor-code-set!
  (c-lambda (XEvent* unsigned-char)
            void
            "___arg1->xerror.minor_code = ___arg2;"))

;; XGenericEvent accessors

