;; XAnyEvent accessors

(define x-any-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xany.type;"))

(define set-x-any-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xany.type = ___arg2;"))

(define x-any-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xany.serial;"))

(define set-x-any-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xany.serial = ___arg2;"))

(define x-any-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xany.send_event;"))

(define set-x-any-event-send-event!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xany.send_event = ___arg2;"))

(define x-any-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xany.display;"))

(define set-x-any-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xany.display = ___arg2;"))

(define x-any-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xany.window;"))

(define set-x-any-event-window!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xany.window = ___arg2;"))

;; XKeyEvent accessors

(define x-key-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xkey.type;"))

(define set-x-key-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xkey.type = ___arg2;"))

(define x-key-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xkey.serial;"))

(define set-x-key-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xkey.serial = ___arg2;"))

(define x-key-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xkey.send_event;"))

(define set-x-key-event-send-event!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xkey.send_event = ___arg2;"))

(define x-key-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xkey.display;"))

(define set-x-key-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xkey.display = ___arg2;"))

(define x-key-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xkey.window;"))

(define set-x-key-event-window!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xkey.window = ___arg2;"))

(define x-key-event-root
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xkey.root;"))

(define set-x-key-event-root!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xkey.root = ___arg2;"))

(define x-key-event-subwindow
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xkey.subwindow;"))

(define set-x-key-event-subwindow!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xkey.subwindow = ___arg2;"))

(define x-key-event-time
  (c-lambda (XEvent*) 
            Time 
            "___result = ___arg1->xkey.time;"))

(define set-x-key-event-time!
  (c-lambda (XEvent* Time)
            void
            "___arg1->xkey.time = ___arg2;"))

(define x-key-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xkey.x;"))

(define set-x-key-event-x!
  (c-lambda (XEvent* int)
            void
            "___arg1->xkey.x = ___arg2;"))

(define x-key-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xkey.y;"))

(define set-x-key-event-y!
  (c-lambda (XEvent* int)
            void
            "___arg1->xkey.y = ___arg2;"))

(define x-key-event-x-root
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xkey.x_root;"))

(define set-x-key-event-x-root!
  (c-lambda (XEvent* int)
            void
            "___arg1->xkey.x_root = ___arg2;"))

(define x-key-event-y-root
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xkey.y_root;"))

(define set-x-key-event-y-root!
  (c-lambda (XEvent* int)
            void
            "___arg1->xkey.y_root = ___arg2;"))

(define x-key-event-state
  (c-lambda (XEvent*) 
            unsigned-int 
            "___result = ___arg1->xkey.state;"))

(define set-x-key-event-state!
  (c-lambda (XEvent* unsigned-int)
            void
            "___arg1->xkey.state = ___arg2;"))

(define x-key-event-keycode
  (c-lambda (XEvent*) 
            unsigned-int 
            "___result = ___arg1->xkey.keycode;"))

(define set-x-key-event-keycode!
  (c-lambda (XEvent* unsigned-int)
            void
            "___arg1->xkey.keycode = ___arg2;"))

(define x-key-event-same-screen?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xkey.same_screen;"))

(define set-x-key-event-same-screen!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xkey.same_screen = ___arg2;"))

;; XButtonEvent accessors

(define x-button-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xbutton.type;"))

(define set-x-button-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xbutton.type = ___arg2;"))

(define x-button-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xbutton.serial;"))

(define set-x-button-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xbutton.serial = ___arg2;"))

(define x-button-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xbutton.send_event;"))

(define set-x-button-event-send-event!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xbutton.send_event = ___arg2;"))

(define x-button-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xbutton.display;"))

(define set-x-button-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xbutton.display = ___arg2;"))

(define x-button-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xbutton.window;"))

(define set-x-button-event-window!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xbutton.window = ___arg2;"))

(define x-button-event-root
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xbutton.root;"))

(define set-x-button-event-root!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xbutton.root = ___arg2;"))

(define x-button-event-subwindow
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xbutton.subwindow;"))

(define set-x-button-event-subwindow!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xbutton.subwindow = ___arg2;"))

(define x-button-event-time
  (c-lambda (XEvent*) 
            Time 
            "___result = ___arg1->xbutton.time;"))

(define set-x-button-event-time!
  (c-lambda (XEvent* Time)
            void
            "___arg1->xbutton.time = ___arg2;"))

(define x-button-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xbutton.x;"))

(define set-x-button-event-x!
  (c-lambda (XEvent* int)
            void
            "___arg1->xbutton.x = ___arg2;"))

(define x-button-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xbutton.y;"))

(define set-x-button-event-y!
  (c-lambda (XEvent* int)
            void
            "___arg1->xbutton.y = ___arg2;"))

(define x-button-event-x-root
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xbutton.x_root;"))

(define set-x-button-event-x-root!
  (c-lambda (XEvent* int)
            void
            "___arg1->xbutton.x_root = ___arg2;"))

(define x-button-event-y-root
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xbutton.y_root;"))

(define set-x-button-event-y-root!
  (c-lambda (XEvent* int)
            void
            "___arg1->xbutton.y_root = ___arg2;"))

(define x-button-event-state
  (c-lambda (XEvent*) 
            unsigned-int 
            "___result = ___arg1->xbutton.state;"))

(define set-x-button-event-state!
  (c-lambda (XEvent* unsigned-int)
            void
            "___arg1->xbutton.state = ___arg2;"))

(define x-button-event-button
  (c-lambda (XEvent*) 
            unsigned-int 
            "___result = ___arg1->xbutton.button;"))

(define set-x-button-event-button!
  (c-lambda (XEvent* unsigned-int)
            void
            "___arg1->xbutton.button = ___arg2;"))

(define x-button-event-same-screen?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xbutton.same_screen;"))

(define set-x-button-event-same-screen!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xbutton.same_screen = ___arg2;"))

;; XMotionEvent accessors

(define x-motion-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xmotion.type;"))

(define set-x-motion-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xmotion.type = ___arg2;"))

(define x-motion-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xmotion.serial;"))

(define set-x-motion-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xmotion.serial = ___arg2;"))

(define x-motion-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xmotion.send_event;"))

(define set-x-motion-event-send-event!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xmotion.send_event = ___arg2;"))

(define x-motion-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xmotion.display;"))

(define set-x-motion-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xmotion.display = ___arg2;"))

(define x-motion-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xmotion.window;"))

(define set-x-motion-event-window!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xmotion.window = ___arg2;"))

(define x-motion-event-root
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xmotion.root;"))

(define set-x-motion-event-root!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xmotion.root = ___arg2;"))

(define x-motion-event-subwindow
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xmotion.subwindow;"))

(define set-x-motion-event-subwindow!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xmotion.subwindow = ___arg2;"))

(define x-motion-event-time
  (c-lambda (XEvent*) 
            Time 
            "___result = ___arg1->xmotion.time;"))

(define set-x-motion-event-time!
  (c-lambda (XEvent* Time)
            void
            "___arg1->xmotion.time = ___arg2;"))

(define x-motion-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xmotion.x;"))

(define set-x-motion-event-x!
  (c-lambda (XEvent* int)
            void
            "___arg1->xmotion.x = ___arg2;"))

(define x-motion-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xmotion.y;"))

(define set-x-motion-event-y!
  (c-lambda (XEvent* int)
            void
            "___arg1->xmotion.y = ___arg2;"))

(define x-motion-event-x-root
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xmotion.x_root;"))

(define set-x-motion-event-x-root!
  (c-lambda (XEvent* int)
            void
            "___arg1->xmotion.x_root = ___arg2;"))

(define x-motion-event-y-root
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xmotion.y_root;"))

(define set-x-motion-event-y-root!
  (c-lambda (XEvent* int)
            void
            "___arg1->xmotion.y_root = ___arg2;"))

(define x-motion-event-state
  (c-lambda (XEvent*) 
            unsigned-int 
            "___result = ___arg1->xmotion.state;"))

(define set-x-motion-event-state!
  (c-lambda (XEvent* unsigned-int)
            void
            "___arg1->xmotion.state = ___arg2;"))

(define x-motion-event-is-hint
  (c-lambda (XEvent*) 
            char 
            "___result = ___arg1->xmotion.is_hint;"))

(define set-x-motion-event-is-hint!
  (c-lambda (XEvent* char)
            void
            "___arg1->xmotion.is_hint = ___arg2;"))

(define x-motion-event-same-screen?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xmotion.same_screen;"))

(define set-x-motion-event-same-screen!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xmotion.same_screen = ___arg2;"))

;; XCrossingEvent accessors

(define x-crossing-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcrossing.type;"))

(define set-x-crossing-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcrossing.type = ___arg2;"))

(define x-crossing-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xcrossing.serial;"))

(define set-x-crossing-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xcrossing.serial = ___arg2;"))

(define x-crossing-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xcrossing.send_event;"))

(define set-x-crossing-event-send-event!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xcrossing.send_event = ___arg2;"))

(define x-crossing-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xcrossing.display;"))

(define set-x-crossing-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xcrossing.display = ___arg2;"))

(define x-crossing-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xcrossing.window;"))

(define set-x-crossing-event-window!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xcrossing.window = ___arg2;"))

(define x-crossing-event-root
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xcrossing.root;"))

(define set-x-crossing-event-root!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xcrossing.root = ___arg2;"))

(define x-crossing-event-subwindow
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xcrossing.subwindow;"))

(define set-x-crossing-event-subwindow!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xcrossing.subwindow = ___arg2;"))

(define x-crossing-event-time
  (c-lambda (XEvent*) 
            Time 
            "___result = ___arg1->xcrossing.time;"))

(define set-x-crossing-event-time!
  (c-lambda (XEvent* Time)
            void
            "___arg1->xcrossing.time = ___arg2;"))

(define x-crossing-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcrossing.x;"))

(define set-x-crossing-event-x!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcrossing.x = ___arg2;"))

(define x-crossing-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcrossing.y;"))

(define set-x-crossing-event-y!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcrossing.y = ___arg2;"))

(define x-crossing-event-x-root
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcrossing.x_root;"))

(define set-x-crossing-event-x-root!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcrossing.x_root = ___arg2;"))

(define x-crossing-event-y-root
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcrossing.y_root;"))

(define set-x-crossing-event-y-root!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcrossing.y_root = ___arg2;"))

(define x-crossing-event-mode
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcrossing.mode;"))

(define set-x-crossing-event-mode!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcrossing.mode = ___arg2;"))

(define x-crossing-event-detail
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcrossing.detail;"))

(define set-x-crossing-event-detail!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcrossing.detail = ___arg2;"))

(define x-crossing-event-same-screen?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xcrossing.same_screen;"))

(define set-x-crossing-event-same-screen!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xcrossing.same_screen = ___arg2;"))

(define x-crossing-event-focus?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xcrossing.focus;"))

(define set-x-crossing-event-focus!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xcrossing.focus = ___arg2;"))

(define x-crossing-event-state
  (c-lambda (XEvent*) 
            unsigned-int 
            "___result = ___arg1->xcrossing.state;"))

(define set-x-crossing-event-state!
  (c-lambda (XEvent* unsigned-int)
            void
            "___arg1->xcrossing.state = ___arg2;"))

;; XFocusChangeEvent accessors

(define x-focus-change-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xfocus.type;"))

(define set-x-focus-change-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xfocus.type = ___arg2;"))

(define x-focus-change-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xfocus.serial;"))

(define set-x-focus-change-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xfocus.serial = ___arg2;"))

(define x-focus-change-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xfocus.send_event;"))

(define set-x-focus-change-event-send-event!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xfocus.send_event = ___arg2;"))

(define x-focus-change-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xfocus.display;"))

(define set-x-focus-change-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xfocus.display = ___arg2;"))

(define x-focus-change-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xfocus.window;"))

(define set-x-focus-change-event-window!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xfocus.window = ___arg2;"))

(define x-focus-change-event-mode
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xfocus.mode;"))

(define set-x-focus-change-event-mode!
  (c-lambda (XEvent* int)
            void
            "___arg1->xfocus.mode = ___arg2;"))

(define x-focus-change-event-detail
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xfocus.detail;"))

(define set-x-focus-change-event-detail!
  (c-lambda (XEvent* int)
            void
            "___arg1->xfocus.detail = ___arg2;"))

;; XKeymapEvent accessors

(define x-keymap-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xkeymap.type;"))

(define set-x-keymap-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xkeymap.type = ___arg2;"))

(define x-keymap-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xkeymap.serial;"))

(define set-x-keymap-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xkeymap.serial = ___arg2;"))

(define x-keymap-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xkeymap.send_event;"))

(define set-x-keymap-event-send-event!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xkeymap.send_event = ___arg2;"))

(define x-keymap-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xkeymap.display;"))

(define set-x-keymap-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xkeymap.display = ___arg2;"))

(define x-keymap-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xkeymap.window;"))

(define set-x-keymap-event-window!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xkeymap.window = ___arg2;"))

;; XExposeEvent accessors

(define x-expose-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xexpose.type;"))

(define set-x-expose-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xexpose.type = ___arg2;"))

(define x-expose-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xexpose.serial;"))

(define set-x-expose-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xexpose.serial = ___arg2;"))

(define x-expose-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xexpose.send_event;"))

(define set-x-expose-event-send-event!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xexpose.send_event = ___arg2;"))

(define x-expose-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xexpose.display;"))

(define set-x-expose-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xexpose.display = ___arg2;"))

(define x-expose-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xexpose.window;"))

(define set-x-expose-event-window!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xexpose.window = ___arg2;"))

(define x-expose-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xexpose.x;"))

(define set-x-expose-event-x!
  (c-lambda (XEvent* int)
            void
            "___arg1->xexpose.x = ___arg2;"))

(define x-expose-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xexpose.y;"))

(define set-x-expose-event-y!
  (c-lambda (XEvent* int)
            void
            "___arg1->xexpose.y = ___arg2;"))

(define x-expose-event-width
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xexpose.width;"))

(define set-x-expose-event-width!
  (c-lambda (XEvent* int)
            void
            "___arg1->xexpose.width = ___arg2;"))

(define x-expose-event-height
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xexpose.height;"))

(define set-x-expose-event-height!
  (c-lambda (XEvent* int)
            void
            "___arg1->xexpose.height = ___arg2;"))

(define x-expose-event-count
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xexpose.count;"))

(define set-x-expose-event-count!
  (c-lambda (XEvent* int)
            void
            "___arg1->xexpose.count = ___arg2;"))

;; XGraphicsExposeEvent accessors

(define x-graphics-expose-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgraphicsexpose.type;"))

(define set-x-graphics-expose-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xgraphicsexpose.type = ___arg2;"))

(define x-graphics-expose-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xgraphicsexpose.serial;"))

(define set-x-graphics-expose-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xgraphicsexpose.serial = ___arg2;"))

(define x-graphics-expose-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xgraphicsexpose.send_event;"))

(define set-x-graphics-expose-event-send-event!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xgraphicsexpose.send_event = ___arg2;"))

(define x-graphics-expose-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xgraphicsexpose.display;"))

(define set-x-graphics-expose-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xgraphicsexpose.display = ___arg2;"))

(define x-graphics-expose-event-drawable
  (c-lambda (XEvent*) 
            Drawable 
            "___result = ___arg1->xgraphicsexpose.drawable;"))

(define set-x-graphics-expose-event-drawable!
  (c-lambda (XEvent* Drawable)
            void
            "___arg1->xgraphicsexpose.drawable = ___arg2;"))

(define x-graphics-expose-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgraphicsexpose.x;"))

(define set-x-graphics-expose-event-x!
  (c-lambda (XEvent* int)
            void
            "___arg1->xgraphicsexpose.x = ___arg2;"))

(define x-graphics-expose-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgraphicsexpose.y;"))

(define set-x-graphics-expose-event-y!
  (c-lambda (XEvent* int)
            void
            "___arg1->xgraphicsexpose.y = ___arg2;"))

(define x-graphics-expose-event-width
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgraphicsexpose.width;"))

(define set-x-graphics-expose-event-width!
  (c-lambda (XEvent* int)
            void
            "___arg1->xgraphicsexpose.width = ___arg2;"))

(define x-graphics-expose-event-height
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgraphicsexpose.height;"))

(define set-x-graphics-expose-event-height!
  (c-lambda (XEvent* int)
            void
            "___arg1->xgraphicsexpose.height = ___arg2;"))

(define x-graphics-expose-event-count
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgraphicsexpose.count;"))

(define set-x-graphics-expose-event-count!
  (c-lambda (XEvent* int)
            void
            "___arg1->xgraphicsexpose.count = ___arg2;"))

(define x-graphics-expose-event-major-code
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgraphicsexpose.major_code;"))

(define set-x-graphics-expose-event-major-code!
  (c-lambda (XEvent* int)
            void
            "___arg1->xgraphicsexpose.major_code = ___arg2;"))

(define x-graphics-expose-event-minor-code
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgraphicsexpose.minor_code;"))

(define set-x-graphics-expose-event-minor-code!
  (c-lambda (XEvent* int)
            void
            "___arg1->xgraphicsexpose.minor_code = ___arg2;"))

;; XNoExposeEvent accessors

(define x-no-expose-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xnoexpose.type;"))

(define set-x-no-expose-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xnoexpose.type = ___arg2;"))

(define x-no-expose-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xnoexpose.serial;"))

(define set-x-no-expose-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xnoexpose.serial = ___arg2;"))

(define x-no-expose-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xnoexpose.send_event;"))

(define set-x-no-expose-event-send-event!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xnoexpose.send_event = ___arg2;"))

(define x-no-expose-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xnoexpose.display;"))

(define set-x-no-expose-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xnoexpose.display = ___arg2;"))

(define x-no-expose-event-drawable
  (c-lambda (XEvent*) 
            Drawable 
            "___result = ___arg1->xnoexpose.drawable;"))

(define set-x-no-expose-event-drawable!
  (c-lambda (XEvent* Drawable)
            void
            "___arg1->xnoexpose.drawable = ___arg2;"))

(define x-no-expose-event-major-code
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xnoexpose.major_code;"))

(define set-x-no-expose-event-major-code!
  (c-lambda (XEvent* int)
            void
            "___arg1->xnoexpose.major_code = ___arg2;"))

(define x-no-expose-event-minor-code
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xnoexpose.minor_code;"))

(define set-x-no-expose-event-minor-code!
  (c-lambda (XEvent* int)
            void
            "___arg1->xnoexpose.minor_code = ___arg2;"))

;; XVisibilityEvent accessors

(define x-visibility-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xvisibility.type;"))

(define set-x-visibility-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xvisibility.type = ___arg2;"))

(define x-visibility-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xvisibility.serial;"))

(define set-x-visibility-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xvisibility.serial = ___arg2;"))

(define x-visibility-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xvisibility.send_event;"))

(define set-x-visibility-event-send-event!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xvisibility.send_event = ___arg2;"))

(define x-visibility-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xvisibility.display;"))

(define set-x-visibility-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xvisibility.display = ___arg2;"))

(define x-visibility-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xvisibility.window;"))

(define set-x-visibility-event-window!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xvisibility.window = ___arg2;"))

(define x-visibility-event-state
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xvisibility.state;"))

(define set-x-visibility-event-state!
  (c-lambda (XEvent* int)
            void
            "___arg1->xvisibility.state = ___arg2;"))

;; XCreateWindowEvent accessors

(define x-create-window-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcreatewindow.type;"))

(define set-x-create-window-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcreatewindow.type = ___arg2;"))

(define x-create-window-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xcreatewindow.serial;"))

(define set-x-create-window-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xcreatewindow.serial = ___arg2;"))

(define x-create-window-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xcreatewindow.send_event;"))

(define set-x-create-window-event-send-event!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xcreatewindow.send_event = ___arg2;"))

(define x-create-window-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xcreatewindow.display;"))

(define set-x-create-window-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xcreatewindow.display = ___arg2;"))

(define x-create-window-event-parent
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xcreatewindow.parent;"))

(define set-x-create-window-event-parent!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xcreatewindow.parent = ___arg2;"))

(define x-create-window-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xcreatewindow.window;"))

(define set-x-create-window-event-window!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xcreatewindow.window = ___arg2;"))

(define x-create-window-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcreatewindow.x;"))

(define set-x-create-window-event-x!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcreatewindow.x = ___arg2;"))

(define x-create-window-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcreatewindow.y;"))

(define set-x-create-window-event-y!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcreatewindow.y = ___arg2;"))

(define x-create-window-event-width
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcreatewindow.width;"))

(define set-x-create-window-event-width!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcreatewindow.width = ___arg2;"))

(define x-create-window-event-height
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcreatewindow.height;"))

(define set-x-create-window-event-height!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcreatewindow.height = ___arg2;"))

(define x-create-window-event-border-width
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcreatewindow.border_width;"))

(define set-x-create-window-event-border-width!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcreatewindow.border_width = ___arg2;"))

(define x-create-window-event-override-redirect?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xcreatewindow.override_redirect;"))

(define set-x-create-window-event-override-redirect!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xcreatewindow.override_redirect = ___arg2;"))

;; XDestroyWindowEvent accessors

(define x-destroy-window-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xdestroywindow.type;"))

(define set-x-destroy-window-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xdestroywindow.type = ___arg2;"))

(define x-destroy-window-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xdestroywindow.serial;"))

(define set-x-destroy-window-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xdestroywindow.serial = ___arg2;"))

(define x-destroy-window-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xdestroywindow.send_event;"))

(define set-x-destroy-window-event-send-event!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xdestroywindow.send_event = ___arg2;"))

(define x-destroy-window-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xdestroywindow.display;"))

(define set-x-destroy-window-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xdestroywindow.display = ___arg2;"))

(define x-destroy-window-event-event
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xdestroywindow.event;"))

(define set-x-destroy-window-event-event!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xdestroywindow.event = ___arg2;"))

(define x-destroy-window-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xdestroywindow.window;"))

(define set-x-destroy-window-event-window!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xdestroywindow.window = ___arg2;"))

;; XUnmapEvent accessors

(define x-unmap-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xunmap.type;"))

(define set-x-unmap-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xunmap.type = ___arg2;"))

(define x-unmap-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xunmap.serial;"))

(define set-x-unmap-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xunmap.serial = ___arg2;"))

(define x-unmap-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xunmap.send_event;"))

(define set-x-unmap-event-send-event!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xunmap.send_event = ___arg2;"))

(define x-unmap-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xunmap.display;"))

(define set-x-unmap-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xunmap.display = ___arg2;"))

(define x-unmap-event-event
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xunmap.event;"))

(define set-x-unmap-event-event!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xunmap.event = ___arg2;"))

(define x-unmap-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xunmap.window;"))

(define set-x-unmap-event-window!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xunmap.window = ___arg2;"))

(define x-unmap-event-from-configure?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xunmap.from_configure;"))

(define set-x-unmap-event-from-configure!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xunmap.from_configure = ___arg2;"))

;; XMapEvent accessors

(define x-map-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xmap.type;"))

(define set-x-map-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xmap.type = ___arg2;"))

(define x-map-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xmap.serial;"))

(define set-x-map-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xmap.serial = ___arg2;"))

(define x-map-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xmap.send_event;"))

(define set-x-map-event-send-event!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xmap.send_event = ___arg2;"))

(define x-map-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xmap.display;"))

(define set-x-map-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xmap.display = ___arg2;"))

(define x-map-event-event
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xmap.event;"))

(define set-x-map-event-event!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xmap.event = ___arg2;"))

(define x-map-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xmap.window;"))

(define set-x-map-event-window!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xmap.window = ___arg2;"))

(define x-map-event-override-redirect?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xmap.override_redirect;"))

(define set-x-map-event-override-redirect?!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xmap.override_redirect = ___arg2;"))

;; XMapRequestEvent accessors

(define x-map-request-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xmaprequest.type;"))

(define set-x-map-request-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xmaprequest.type = ___arg2;"))

(define x-map-request-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xmaprequest.serial;"))

(define set-x-map-request-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xmaprequest.serial = ___arg2;"))

(define x-map-request-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xmaprequest.send_event;"))

(define set-x-map-request-event-send-event?!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xmaprequest.send_event = ___arg2;"))

(define x-map-request-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xmaprequest.display;"))

(define set-x-map-request-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xmaprequest.display = ___arg2;"))

(define x-map-request-event-parent
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xmaprequest.parent;"))

(define set-x-map-request-event-parent!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xmaprequest.parent = ___arg2;"))

(define x-map-request-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xmaprequest.window;"))

(define set-x-map-request-event-window!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xmaprequest.window = ___arg2;"))

;; XReparentEvent accessors

(define x-reparent-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xreparent.type;"))

(define set-x-reparent-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xreparent.type = ___arg2;"))

(define x-reparent-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xreparent.serial;"))

(define set-x-reparent-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xreparent.serial = ___arg2;"))

(define x-reparent-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xreparent.send_event;"))

(define set-x-reparent-event-send-event?!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xreparent.send_event = ___arg2;"))

(define x-reparent-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xreparent.display;"))

(define set-x-reparent-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xreparent.display = ___arg2;"))

(define x-reparent-event-event
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xreparent.event;"))

(define set-x-reparent-event-event!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xreparent.event = ___arg2;"))

(define x-reparent-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xreparent.window;"))

(define set-x-reparent-event-window!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xreparent.window = ___arg2;"))

(define x-reparent-event-parent
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xreparent.parent;"))

(define set-x-reparent-event-parent!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xreparent.parent = ___arg2;"))

(define x-reparent-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xreparent.x;"))

(define set-x-reparent-event-x!
  (c-lambda (XEvent* int)
            void
            "___arg1->xreparent.x = ___arg2;"))

(define x-reparent-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xreparent.y;"))

(define set-x-reparent-event-y!
  (c-lambda (XEvent* int)
            void
            "___arg1->xreparent.y = ___arg2;"))

(define x-reparent-event-override-redirect?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xreparent.override_redirect;"))

(define set-x-reparent-event-override-redirect?!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xreparent.override_redirect = ___arg2;"))

;; XConfigureEvent accessors

(define x-configure-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigure.type;"))

(define set-x-configure-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xconfigure.type = ___arg2;"))

(define x-configure-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xconfigure.serial;"))

(define set-x-configure-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xconfigure.serial = ___arg2;"))

(define x-configure-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xconfigure.send_event;"))

(define set-x-configure-event-send-event?!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xconfigure.send_event = ___arg2;"))

(define x-configure-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xconfigure.display;"))

(define set-x-configure-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xconfigure.display = ___arg2;"))

(define x-configure-event-event
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xconfigure.event;"))

(define set-x-configure-event-event!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xconfigure.event = ___arg2;"))

(define x-configure-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xconfigure.window;"))

(define set-x-configure-event-window!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xconfigure.window = ___arg2;"))

(define x-configure-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigure.x;"))

(define set-x-configure-event-x!
  (c-lambda (XEvent* int)
            void
            "___arg1->xconfigure.x = ___arg2;"))

(define x-configure-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigure.y;"))

(define set-x-configure-event-y!
  (c-lambda (XEvent* int)
            void
            "___arg1->xconfigure.y = ___arg2;"))

(define x-configure-event-width
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigure.width;"))

(define set-x-configure-event-width!
  (c-lambda (XEvent* int)
            void
            "___arg1->xconfigure.width = ___arg2;"))

(define x-configure-event-height
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigure.height;"))

(define set-x-configure-event-height!
  (c-lambda (XEvent* int)
            void
            "___arg1->xconfigure.height = ___arg2;"))

(define x-configure-event-border-width
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigure.border_width;"))

(define set-x-configure-event-border-width!
  (c-lambda (XEvent* int)
            void
            "___arg1->xconfigure.border_width = ___arg2;"))

(define x-configure-event-above
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xconfigure.above;"))

(define set-x-configure-event-above!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xconfigure.above = ___arg2;"))

(define x-configure-event-override-redirect?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xconfigure.override_redirect;"))

(define set-x-configure-event-override-redirect?!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xconfigure.override_redirect = ___arg2;"))

;; XGravityEvent accessors

(define x-gravity-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgravity.type;"))

(define set-x-gravity-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xgravity.type = ___arg2;"))

(define x-gravity-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xgravity.serial;"))

(define set-x-gravity-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xgravity.serial = ___arg2;"))

(define x-gravity-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xgravity.send_event;"))

(define set-x-gravity-event-send-event?!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xgravity.send_event = ___arg2;"))

(define x-gravity-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xgravity.display;"))

(define set-x-gravity-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xgravity.display = ___arg2;"))

(define x-gravity-event-event
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xgravity.event;"))

(define set-x-gravity-event-event!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xgravity.event = ___arg2;"))

(define x-gravity-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xgravity.window;"))

(define set-x-gravity-event-window!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xgravity.window = ___arg2;"))

(define x-gravity-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgravity.x;"))

(define set-x-gravity-event-x!
  (c-lambda (XEvent* int)
            void
            "___arg1->xgravity.x = ___arg2;"))

(define x-gravity-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgravity.y;"))

(define set-x-gravity-event-y!
  (c-lambda (XEvent* int)
            void
            "___arg1->xgravity.y = ___arg2;"))

;; XResizeRequestEvent accessors

(define x-resize-request-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xresizerequest.type;"))

(define set-x-resize-request-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xresizerequest.type = ___arg2;"))

(define x-resize-request-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xresizerequest.serial;"))

(define set-x-resize-request-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xresizerequest.serial = ___arg2;"))

(define x-resize-request-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xresizerequest.send_event;"))

(define set-x-resize-request-event-send-event?!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xresizerequest.send_event = ___arg2;"))

(define x-resize-request-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xresizerequest.display;"))

(define set-x-resize-request-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xresizerequest.display = ___arg2;"))

(define x-resize-request-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xresizerequest.window;"))

(define set-x-resize-request-event-window!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xresizerequest.window = ___arg2;"))

(define x-resize-request-event-width
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xresizerequest.width;"))

(define set-x-resize-request-event-width!
  (c-lambda (XEvent* int)
            void
            "___arg1->xresizerequest.width = ___arg2;"))

(define x-resize-request-event-height
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xresizerequest.height;"))

(define set-x-resize-request-event-height!
  (c-lambda (XEvent* int)
            void
            "___arg1->xresizerequest.height = ___arg2;"))

;; XConfigureRequestEvent accessors

(define x-configure-request-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigurerequest.type;"))

(define set-x-configure-request-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xconfigurerequest.type = ___arg2;"))

(define x-configure-request-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xconfigurerequest.serial;"))

(define set-x-configure-request-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xconfigurerequest.serial = ___arg2;"))

(define x-configure-request-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xconfigurerequest.send_event;"))

(define set-x-configure-request-event-send-event?!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xconfigurerequest.send_event = ___arg2;"))

(define x-configure-request-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xconfigurerequest.display;"))

(define set-x-configure-request-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xconfigurerequest.display = ___arg2;"))

(define x-configure-request-event-parent
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xconfigurerequest.parent;"))

(define set-x-configure-request-event-parent!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xconfigurerequest.parent = ___arg2;"))

(define x-configure-request-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xconfigurerequest.window;"))

(define set-x-configure-request-event-window!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xconfigurerequest.window = ___arg2;"))

(define x-configure-request-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigurerequest.x;"))

(define set-x-configure-request-event-x!
  (c-lambda (XEvent* int)
            void
            "___arg1->xconfigurerequest.x = ___arg2;"))

(define x-configure-request-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigurerequest.y;"))

(define set-x-configure-request-event-y!
  (c-lambda (XEvent* int)
            void
            "___arg1->xconfigurerequest.y = ___arg2;"))

(define x-configure-request-event-width
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigurerequest.width;"))

(define set-x-configure-request-event-width!
  (c-lambda (XEvent* int)
            void
            "___arg1->xconfigurerequest.width = ___arg2;"))

(define x-configure-request-event-height
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigurerequest.height;"))

(define set-x-configure-request-event-height!
  (c-lambda (XEvent* int)
            void
            "___arg1->xconfigurerequest.height = ___arg2;"))

(define x-configure-request-event-border-width
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigurerequest.border_width;"))

(define set-x-configure-request-event-border-width!
  (c-lambda (XEvent* int)
            void
            "___arg1->xconfigurerequest.border_width = ___arg2;"))

(define x-configure-request-event-above
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xconfigurerequest.above;"))

(define set-x-configure-request-event-above!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xconfigurerequest.above = ___arg2;"))

(define x-configure-request-event-detail
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigurerequest.detail;"))

(define set-x-configure-request-event-detail!
  (c-lambda (XEvent* int)
            void
            "___arg1->xconfigurerequest.detail = ___arg2;"))

(define x-configure-request-event-value-mask
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xconfigurerequest.value_mask;"))

(define set-x-configure-request-event-value-mask!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xconfigurerequest.value_mask = ___arg2;"))

;; XCirculateEvent accessors

(define x-circulate-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcirculate.type;"))

(define set-x-circulate-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcirculate.type = ___arg2;"))

(define x-circulate-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xcirculate.serial;"))

(define set-x-circulate-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xcirculate.serial = ___arg2;"))

(define x-circulate-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xcirculate.send_event;"))

(define set-x-circulate-event-send-event?!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xcirculate.send_event = ___arg2;"))

(define x-circulate-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xcirculate.display;"))

(define set-x-circulate-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xcirculate.display = ___arg2;"))

(define x-circulate-event-event
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xcirculate.event;"))

(define set-x-circulate-event-event!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xcirculate.event = ___arg2;"))

(define x-circulate-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xcirculate.window;"))

(define set-x-circulate-event-window!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xcirculate.window = ___arg2;"))

(define x-circulate-event-place
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcirculate.place;"))

(define set-x-circulate-event-place!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcirculate.place = ___arg2;"))

;; XCirculateRequestEvent accessors

(define x-circulate-request-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcirculaterequest.type;"))

(define set-x-circulate-request-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcirculaterequest.type = ___arg2;"))

(define x-circulate-request-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xcirculaterequest.serial;"))

(define set-x-circulate-request-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xcirculaterequest.serial = ___arg2;"))

(define x-circulate-request-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xcirculaterequest.send_event;"))

(define set-x-circulate-request-event-send-event?!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xcirculaterequest.send_event = ___arg2;"))

(define x-circulate-request-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xcirculaterequest.display;"))

(define set-x-circulate-request-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xcirculaterequest.display = ___arg2;"))

(define x-circulate-request-event-parent
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xcirculaterequest.parent;"))

(define set-x-circulate-request-event-parent!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xcirculaterequest.parent = ___arg2;"))

(define x-circulate-request-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xcirculaterequest.window;"))

(define set-x-circulate-request-event-window!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xcirculaterequest.window = ___arg2;"))

(define x-circulate-request-event-place
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcirculaterequest.place;"))

(define set-x-circulate-request-event-place!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcirculaterequest.place = ___arg2;"))

;; XPropertyEvent accessors

(define x-property-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xproperty.type;"))

(define set-x-property-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xproperty.type = ___arg2;"))

(define x-property-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xproperty.serial;"))

(define set-x-property-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xproperty.serial = ___arg2;"))

(define x-property-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xproperty.send_event;"))

(define set-x-property-event-send-event?!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xproperty.send_event = ___arg2;"))

(define x-property-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xproperty.display;"))

(define set-x-property-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xproperty.display = ___arg2;"))

(define x-property-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xproperty.window;"))

(define set-x-property-event-window!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xproperty.window = ___arg2;"))

(define x-property-event-atom
  (c-lambda (XEvent*) 
            Atom 
            "___result = ___arg1->xproperty.atom;"))

(define set-x-property-event-atom!
  (c-lambda (XEvent* Atom)
            void
            "___arg1->xproperty.atom = ___arg2;"))

(define x-property-event-time
  (c-lambda (XEvent*) 
            Time 
            "___result = ___arg1->xproperty.time;"))

(define set-x-property-event-time!
  (c-lambda (XEvent* Time)
            void
            "___arg1->xproperty.time = ___arg2;"))

(define x-property-event-state
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xproperty.state;"))

(define set-x-property-event-state!
  (c-lambda (XEvent* int)
            void
            "___arg1->xproperty.state = ___arg2;"))

;; XSelectionClearEvent accessors

(define x-selection-clear-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xselectionclear.type;"))

(define set-x-selection-clear-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xselectionclear.type = ___arg2;"))

(define x-selection-clear-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xselectionclear.serial;"))

(define set-x-selection-clear-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xselectionclear.serial = ___arg2;"))

(define x-selection-clear-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xselectionclear.send_event;"))

(define set-x-selection-clear-event-send-event?!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xselectionclear.send_event = ___arg2;"))

(define x-selection-clear-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xselectionclear.display;"))

(define set-x-selection-clear-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xselectionclear.display = ___arg2;"))

(define x-selection-clear-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xselectionclear.window;"))

(define set-x-selection-clear-event-window!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xselectionclear.window = ___arg2;"))

(define x-selection-clear-event-selection
  (c-lambda (XEvent*) 
            Atom 
            "___result = ___arg1->xselectionclear.selection;"))

(define set-x-selection-clear-event-selection!
  (c-lambda (XEvent* Atom)
            void
            "___arg1->xselectionclear.selection = ___arg2;"))

(define x-selection-clear-event-time
  (c-lambda (XEvent*) 
            Time 
            "___result = ___arg1->xselectionclear.time;"))

(define set-x-selection-clear-event-time!
  (c-lambda (XEvent* Time)
            void
            "___arg1->xselectionclear.time = ___arg2;"))

;; XSelectionRequestEvent accessors

(define x-selection-request-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xselectionrequest.type;"))

(define set-x-selection-request-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xselectionrequest.type = ___arg2;"))

(define x-selection-request-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xselectionrequest.serial;"))

(define set-x-selection-request-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xselectionrequest.serial = ___arg2;"))

(define x-selection-request-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xselectionrequest.send_event;"))

(define set-x-selection-request-event-send-event?!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xselectionrequest.send_event = ___arg2;"))

(define x-selection-request-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xselectionrequest.display;"))

(define set-x-selection-request-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xselectionrequest.display = ___arg2;"))

(define x-selection-request-event-owner
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xselectionrequest.owner;"))

(define set-x-selection-request-event-owner!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xselectionrequest.owner = ___arg2;"))

(define x-selection-request-event-requestor
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xselectionrequest.requestor;"))

(define set-x-selection-request-event-requestor!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xselectionrequest.requestor = ___arg2;"))

(define x-selection-request-event-selection
  (c-lambda (XEvent*) 
            Atom 
            "___result = ___arg1->xselectionrequest.selection;"))

(define set-x-selection-request-event-selection!
  (c-lambda (XEvent* Atom)
            void
            "___arg1->xselectionrequest.selection = ___arg2;"))

(define x-selection-request-event-target
  (c-lambda (XEvent*) 
            Atom 
            "___result = ___arg1->xselectionrequest.target;"))

(define set-x-selection-request-event-target!
  (c-lambda (XEvent* Atom)
            void
            "___arg1->xselectionrequest.target = ___arg2;"))

(define x-selection-request-event-property
  (c-lambda (XEvent*) 
            Atom 
            "___result = ___arg1->xselectionrequest.property;"))

(define set-x-selection-request-event-property!
  (c-lambda (XEvent* Atom)
            void
            "___arg1->xselectionrequest.property = ___arg2;"))

(define x-selection-request-event-time
  (c-lambda (XEvent*) 
            Time 
            "___result = ___arg1->xselectionrequest.time;"))

(define set-x-selection-request-event-time!
  (c-lambda (XEvent* Time)
            void
            "___arg1->xselectionrequest.time = ___arg2;"))

;; XSelectionEvent accessors

(define x-selection-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xselection.type;"))

(define set-x-selection-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xselection.type = ___arg2;"))

(define x-selection-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xselection.serial;"))

(define set-x-selection-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xselection.serial = ___arg2;"))

(define x-selection-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xselection.send_event;"))

(define set-x-selection-event-send-event?!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xselection.send_event = ___arg2;"))

(define x-selection-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xselection.display;"))

(define set-x-selection-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xselection.display = ___arg2;"))

(define x-selection-event-requestor
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xselection.requestor;"))

(define set-x-selection-event-requestor!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xselection.requestor = ___arg2;"))

(define x-selection-event-selection
  (c-lambda (XEvent*) 
            Atom 
            "___result = ___arg1->xselection.selection;"))

(define set-x-selection-event-selection!
  (c-lambda (XEvent* Atom)
            void
            "___arg1->xselection.selection = ___arg2;"))

(define x-selection-event-target
  (c-lambda (XEvent*) 
            Atom 
            "___result = ___arg1->xselection.target;"))

(define set-x-selection-event-target!
  (c-lambda (XEvent* Atom)
            void
            "___arg1->xselection.target = ___arg2;"))

(define x-selection-event-property
  (c-lambda (XEvent*) 
            Atom 
            "___result = ___arg1->xselection.property;"))

(define set-x-selection-event-property!
  (c-lambda (XEvent* Atom)
            void
            "___arg1->xselection.property = ___arg2;"))

(define x-selection-event-time
  (c-lambda (XEvent*) 
            Time 
            "___result = ___arg1->xselection.time;"))

(define set-x-selection-event-time!
  (c-lambda (XEvent* Time)
            void
            "___arg1->xselection.time = ___arg2;"))

;; XColormapEvent accessors

(define x-colormap-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcolormap.type;"))

(define set-x-colormap-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcolormap.type = ___arg2;"))

(define x-colormap-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xcolormap.serial;"))

(define set-x-colormap-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xcolormap.serial = ___arg2;"))

(define x-colormap-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xcolormap.send_event;"))

(define set-x-colormap-event-send-event?!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xcolormap.send_event = ___arg2;"))

(define x-colormap-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xcolormap.display;"))

(define set-x-colormap-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xcolormap.display = ___arg2;"))

(define x-colormap-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xcolormap.window;"))

(define set-x-colormap-event-window!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xcolormap.window = ___arg2;"))

(define x-colormap-event-colormap
  (c-lambda (XEvent*) 
            Colormap 
            "___result = ___arg1->xcolormap.colormap;"))

(define set-x-colormap-event-colormap!
  (c-lambda (XEvent* Colormap)
            void
            "___arg1->xcolormap.colormap = ___arg2;"))

(define x-colormap-event-new?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xcolormap.new;"))

(define set-x-colormap-event-new?!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xcolormap.new = ___arg2;"))

(define x-colormap-event-state
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcolormap.state;"))

(define set-x-colormap-event-state!
  (c-lambda (XEvent* int)
            void
            "___arg1->xcolormap.state = ___arg2;"))

;; XClientMessageEvent accessors

(define x-client-message-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xclient.type;"))

(define set-x-client-message-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xclient.type = ___arg2;"))

(define x-client-message-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xclient.serial;"))

(define set-x-client-message-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xclient.serial = ___arg2;"))

(define x-client-message-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xclient.send_event;"))

(define set-x-client-message-event-send-event?!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xclient.send_event = ___arg2;"))

(define x-client-message-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xclient.display;"))

(define set-x-client-message-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xclient.display = ___arg2;"))

(define x-client-message-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xclient.window;"))

(define set-x-client-message-event-window!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xclient.window = ___arg2;"))

(define x-client-message-event-message-type
  (c-lambda (XEvent*) 
            Atom 
            "___result = ___arg1->xclient.message_type;"))

(define set-x-client-message-event-message-type!
  (c-lambda (XEvent* Atom)
            void
            "___arg1->xclient.message_type = ___arg2;"))

(define x-client-message-event-format
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xclient.format;"))

(define set-x-client-message-event-format!
  (c-lambda (XEvent* int)
            void
            "___arg1->xclient.format = ___arg2;"))

;; XMappingEvent accessors

(define x-mapping-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xmapping.type;"))

(define set-x-mapping-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xmapping.type = ___arg2;"))

(define x-mapping-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xmapping.serial;"))

(define set-x-mapping-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xmapping.serial = ___arg2;"))

(define x-mapping-event-send-event?
  (c-lambda (XEvent*) 
            bool 
            "___result = ___arg1->xmapping.send_event;"))

(define set-x-mapping-event-send-event?!
  (c-lambda (XEvent* bool)
            void
            "___arg1->xmapping.send_event = ___arg2;"))

(define x-mapping-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xmapping.display;"))

(define set-x-mapping-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xmapping.display = ___arg2;"))

(define x-mapping-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xmapping.window;"))

(define set-x-mapping-event-window!
  (c-lambda (XEvent* Window)
            void
            "___arg1->xmapping.window = ___arg2;"))

(define x-mapping-event-request
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xmapping.request;"))

(define set-x-mapping-event-request!
  (c-lambda (XEvent* int)
            void
            "___arg1->xmapping.request = ___arg2;"))

(define x-mapping-event-first-keycode
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xmapping.first_keycode;"))

(define set-x-mapping-event-first-keycode!
  (c-lambda (XEvent* int)
            void
            "___arg1->xmapping.first_keycode = ___arg2;"))

(define x-mapping-event-count
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xmapping.count;"))

(define set-x-mapping-event-count!
  (c-lambda (XEvent* int)
            void
            "___arg1->xmapping.count = ___arg2;"))

;; XErrorEvent accessors

(define x-error-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xerror.type;"))

(define set-x-error-event-type!
  (c-lambda (XEvent* int)
            void
            "___arg1->xerror.type = ___arg2;"))

(define x-error-event-display
  (c-lambda (XEvent*) 
            Display* 
            "___result_voidstar = ___arg1->xerror.display;"))

(define set-x-error-event-display!
  (c-lambda (XEvent* Display*)
            void
            "___arg1->xerror.display = ___arg2;"))

(define x-error-event-resourceid
  (c-lambda (XEvent*) 
            XID 
            "___result = ___arg1->xerror.resourceid;"))

(define set-x-error-event-resourceid!
  (c-lambda (XEvent* XID)
            void
            "___arg1->xerror.resourceid = ___arg2;"))

(define x-error-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xerror.serial;"))

(define set-x-error-event-serial!
  (c-lambda (XEvent* unsigned-long)
            void
            "___arg1->xerror.serial = ___arg2;"))

(define x-error-event-error-code
  (c-lambda (XEvent*) 
            unsigned-char 
            "___result = ___arg1->xerror.error_code;"))

(define set-x-error-event-error-code!
  (c-lambda (XEvent* unsigned-char)
            void
            "___arg1->xerror.error_code = ___arg2;"))

(define x-error-event-request-code
  (c-lambda (XEvent*) 
            unsigned-char 
            "___result = ___arg1->xerror.request_code;"))

(define set-x-error-event-request-code!
  (c-lambda (XEvent* unsigned-char)
            void
            "___arg1->xerror.request_code = ___arg2;"))

(define x-error-event-minor-code
  (c-lambda (XEvent*) 
            unsigned-char 
            "___result = ___arg1->xerror.minor_code;"))

(define set-x-error-event-minor-code!
  (c-lambda (XEvent* unsigned-char)
            void
            "___arg1->xerror.minor_code = ___arg2;"))

;; XGenericEvent accessors

