;;;============================================================================

;;; File: "Xlib.scm", Time-stamp: <2009-01-13 14:06:51 feeley>

;;; Copyright (c) 2006-2009 by Marc Feeley, All Rights Reserved.

;;; A simple interface to the X Window System Xlib library.

;; Note: This interface to Xlib is still in development.  There are
;;       still memory leaks in the interface.

;;;============================================================================

(##namespace ("Xlib#"))

(##include "~~lib/gambit#.scm")

(##include "Xlib#.scm")

(declare
  (standard-bindings)
  (extended-bindings)
  (block)
  (not safe))

(define-macro (%eval-when-load expr)
  (eval expr)
	`(begin))

;;;============================================================================

(c-declare "
#include <X11/Xlib.h>
#include <X11/Xutil.h>
")

;; Declare a few types so that the function prototypes use the same
;; type names as a C program.

(c-define-type char* char-string)
(c-define-type Time unsigned-long)
(c-define-type XID unsigned-long)
(c-define-type Atom unsigned-long)

(c-define-type Bool int)
(c-define-type Status int)

(c-define-type Window XID)
(c-define-type Drawable XID)
(c-define-type Font XID)
(c-define-type Pixmap XID)
(c-define-type Cursor XID)
(c-define-type Colormap XID)
(c-define-type GContext XID)
(c-define-type KeySym XID)

(c-declare #<<end-of-c-declare

#define debug_free_not
#define really_free

#ifdef debug_free
#include <stdio.h>
#endif

___SCMOBJ XFree_GC( void* ptr )
{ GC p = ptr;
#ifdef debug_free
  printf( "XFree_GC(%p)\n", p );
  fflush( stdout );
#endif
#ifdef really_free
  XFree( p );
#endif
  return ___FIX(___NO_ERR);
}

end-of-c-declare
)

(%eval-when-load
	(define (%string-replace new old str)
		(list->string (map (lambda (c)
												 (if (char=? c old)
														 new
														 c))
											 (string->list str)))))

(define-macro (%c-define-x-object name type)
  (let* ((sym (string->symbol name))
				 (ptr (string->symbol (string-append name "*")))
				 (ptr/free (string->symbol (string-append name "*/" type)))
				 (releaser (string-append type "_" name))
				 (c-releaser (%string-replace #\_ #\- releaser)))
		`(begin
			 (c-declare
				 ,(string-append
						"___SCMOBJ " c-releaser "(void *ptr)\n"
						"{\n"
						name " *p = ptr;\n"
						"#ifdef debug_free\n"
						"printf(\"" c-releaser "(%p)\\n\", p);\n"
						"fflush(stdout);\n"
						"#endif\n"
						"#ifdef really_free\n"
						(cond
							((string=? type "release-rc")
							 "___EXT(___release_rc)(p);\n")
							((string=? type "XFree")
							 "XFree(p);\n"))
						"#endif\n"
						"return ___FIX(___NO_ERR);\n"
						"}\n"))
			 (c-define-type ,sym ,name)
			 (c-define-type ,ptr (pointer ,sym (,ptr)))
			 (c-define-type ,ptr/free (pointer ,sym (,ptr) ,c-releaser)))))

(define-macro (%c-define-const name type c-name)
  `((c-lambda () ,type ,(string-append "___result = " c-name ";"))))

(c-define-type GC (pointer (struct "_XGC") (GC)))
(c-define-type GC/XFree (pointer (struct "_XGC") (GC) "XFree_GC"))

(%c-define-x-object "XGCValues" "release-rc")
(%c-define-x-object "XEvent" "release-rc")
(%c-define-x-object "XColor" "release-rc")
(%c-define-x-object "Visual" "XFree")
(%c-define-x-object "Screen" "XFree")
(%c-define-x-object "XFontStruct" "XFree")
(%c-define-x-object "Display" "XFree")
(%c-define-x-object "XWindowAttributes" "release-rc")

(##include "Xlib-events#.scm")
(##include "Xlib-accessors#.scm")

(define x-open-display
  (c-lambda (char*)        ;; display_name
            Display*/XFree
            "XOpenDisplay"))

(define x-close-display
  (c-lambda (Display*)     ;; display
            int
            "XCloseDisplay"))

(define x-display-width
  (c-lambda (Display* int)
            int
            "DisplayWidth"))

(define x-display-height
  (c-lambda (Display* int)
            int
            "DisplayHeight"))

(define x-default-screen
  (c-lambda (Display*)     ;; display
            int
            "XDefaultScreen"))

(define x-screen-count
  (c-lambda (Display*)     ;; display
            int
            "ScreenCount"))

(define x-screen-of-display
  (c-lambda (Display*      ;; display
             int)          ;; screen_number
            Screen*/XFree
            "XScreenOfDisplay"))

(define x-default-colormap-of-screen
  (c-lambda (Screen*)      ;; screen
            Colormap
            "XDefaultColormapOfScreen"))

(define x-clear-window
  (c-lambda (Display*      ;; display
             Window)       ;; w
            int
            "XClearWindow"))

(define x-connection-number
  (c-lambda (Display*)     ;; display
            int
            "XConnectionNumber"))

(define x-root-window
  (c-lambda (Display*      ;; display
             int)          ;; screen_number
            Window
            "XRootWindow"))

(define x-default-root-window
  (c-lambda (Display*)     ;; display
            Window
            "XDefaultRootWindow"))

(define x-root-window-of-screen
  (c-lambda (Screen*)      ;; screen
            Window
            "XRootWindowOfScreen"))

(define x-default-visual
  (c-lambda (Display*      ;; display
             int)          ;; screen_number
            Visual*/XFree
            "XDefaultVisual"))

(define x-default-visual-of-screen
  (c-lambda (Screen*)      ;; screen
            Visual*/XFree
            "XDefaultVisualOfScreen"))

(define x-default-gc
  (c-lambda (Display*      ;; display
             int)          ;; screen_number
            GC/XFree
            "XDefaultGC"))

(define x-default-gc-of-screen
  (c-lambda (Screen*)      ;; screen
            GC/XFree
            "XDefaultGCOfScreen"))

(define x-black-pixel
  (c-lambda (Display*       ;; display
             int)           ;; screen_number
            unsigned-long
            "XBlackPixel"))

(define x-white-pixel
  (c-lambda (Display*       ;; display
             int)           ;; screen_number
            unsigned-long
            "XWhitePixel"))

(define x-create-simple-window
  (c-lambda (Display*       ;; display
             Window         ;; parent
             int            ;; x
             int            ;; y
             unsigned-int   ;; width
             unsigned-int   ;; height
             unsigned-int   ;; border_width
             unsigned-long  ;; border
             unsigned-long) ;; backgound
            Window
            "XCreateSimpleWindow"))

(define x-map-window
  (c-lambda (Display*       ;; display
             Window)        ;; w
            int
            "XMapWindow"))

(define x-flush
  (c-lambda (Display*)      ;; display
            int
            "XFlush"))

(define x-sync
  (c-lambda (Display*
             bool)
            int
            "XSync"))

(define x-create-gc
  (c-lambda (Display*       ;; display
             Drawable       ;; d
             unsigned-long  ;; valuemask
             XGCValues*)    ;; values
            GC/XFree
            "XCreateGC"))

(define x-fill-rectangle
  (c-lambda (Display*      ;; display
             Drawable      ;; d
             GC            ;; gc
             int           ;; x
             int           ;; y
             unsigned-int  ;; width
             unsigned-int) ;; height
            int
            "XFillRectangle"))

(define x-fill-arc
  (c-lambda (Display*      ;; display
             Drawable      ;; d
             GC            ;; gc
             int           ;; x
             int           ;; y
             unsigned-int  ;; width
             unsigned-int  ;; height
             int           ;; angle1
             int)          ;; angle2
            int
            "XFillArc"))

(define x-draw-string
  (c-lambda (Display*      ;; display
             Drawable      ;; d
             GC            ;; gc
             int           ;; x
             int           ;; y
             char*         ;; string
             int)          ;; length
            int
            "XDrawString"))

(define x-text-width
  (c-lambda (XFontStruct*  ;; font_struct
             char*         ;; string
             int)          ;; count
            int
            "XTextWidth"))

(define x-parse-color
  (c-lambda (Display*      ;; display
             Colormap      ;; colormap
             char*         ;; spec
             XColor*)      ;; exact_def_return
            Status
            "XParseColor"))

(define x-alloc-color
  (c-lambda (Display*      ;; display
             Colormap      ;; colormap
             XColor*)      ;; screen_in_out
            Status
            "XAllocColor"))

(define (make-x-color-box)
  ((c-lambda ()
             XColor*/release-rc
             "___result_voidstar = ___EXT(___alloc_rc) (sizeof (XColor));")))

(define x-color-pixel
  (c-lambda (XColor*)       ;; XColor box
             unsigned-long
            "___result = ___arg1->pixel;"))

(define x-color-pixel-set!
  (c-lambda (XColor*        ;; XColor box
             unsigned-long) ;; intensity
            void
            "___arg1->pixel = ___arg2;"))

(define x-color-red
  (c-lambda (XColor*)       ;; XColor box
             unsigned-short
            "___result = ___arg1->red;"))

(define x-color-red-set!
  (c-lambda (XColor*        ;; XColor box
             unsigned-short);; intensity
            void
            "___arg1->red = ___arg2;"))

(define x-color-green
  (c-lambda (XColor*)       ;; XColor box
             unsigned-short
            "___result = ___arg1->green;"))

(define x-color-green-set!
  (c-lambda (XColor*        ;; XColor box
             unsigned-short);; intensity
            void
            "___arg1->green = ___arg2;"))

(define x-color-blue
  (c-lambda (XColor*)       ;; XColor box
             unsigned-short
            "___result = ___arg1->blue;"))

(define x-color-blue-set!
  (c-lambda (XColor*        ;; XColor box
             unsigned-short);; intensity
            void
            "___arg1->blue = ___arg2;"))

(define (make-x-gc-values-box)
  ((c-lambda ()
             XGCValues*/release-rc
             "___result_voidstar = ___EXT(___alloc_rc) (sizeof (XGCValues));")))

(define x-gc-values-foreground
  (c-lambda (XGCValues*)    ;; XGCValues box
            unsigned-long
            "return ___arg1->foreground;"))

(define x-gc-values-foreground-set!
  (c-lambda (XGCValues*     ;; XGCValues box
             unsigned-long) ;; pixel index
            void
            "___arg1->foreground = ___arg2;"))

(define x-gc-values-background
  (c-lambda (XGCValues*)    ;; XGCValues box
            unsigned-long
            "return ___arg1->background;"))

(define x-gc-values-background-set!
  (c-lambda (XGCValues*     ;; XGCValues box
             unsigned-long) ;; pixel index
            void
            "___arg1->background = ___arg2;"))

(define x-gc-values-font
  (c-lambda (XGCValues*)    ;; XGCValues box
            Font
            "return ___arg1->font;"))

(define x-gc-values-font-set!
  (c-lambda (XGCValues*     ;; XGCValues box
             Font)          ;; font_ID
            void
            "___arg1->font = ___arg2;"))

(%c-define-const +x-none+ unsigned-long "None")
(%c-define-const x-gc-function unsigned-long "GCFunction")
(%c-define-const x-gc-plane-mask unsigned-long "GCPlaneMask")
(%c-define-const x-gc-foreground unsigned-long "GCForeground")
(%c-define-const x-gc-background unsigned-long "GCBackground")
(%c-define-const x-gc-line-width unsigned-long "GCLineWidth")
(%c-define-const x-gc-line-style unsigned-long "GCLineStyle")
(%c-define-const x-gc-cap-style unsigned-long "GCCapStyle")
(%c-define-const x-gc-join-style unsigned-long "GCJoinStyle")
(%c-define-const x-gc-fill-style unsigned-long "GCFillStyle")
(%c-define-const x-gc-fill-rule unsigned-long "GCFillRule")
(%c-define-const x-gc-tile unsigned-long "GCTile")
(%c-define-const x-gc-stipple unsigned-long "GCStipple")
(%c-define-const x-gc-tile-stip-x-origin unsigned-long "GCTileStipXOrigin")
(%c-define-const x-gc-tile-stip-y-origin unsigned-long "GCTileStipYOrigin")
(%c-define-const x-gc-font unsigned-long "GCFont")
(%c-define-const x-gc-subwindow-mode unsigned-long "GCSubwindowMode")
(%c-define-const x-gc-graphics-exposures unsigned-long "GCGraphicsExposures")
(%c-define-const x-gc-clip-x-origin unsigned-long "GCClipXOrigin")
(%c-define-const x-gc-clip-y-origin unsigned-long "GCClipYOrigin")
(%c-define-const x-gc-clip-mask unsigned-long "GCClipMask")
(%c-define-const x-gc-dash-offset unsigned-long "GCDashOffset")
(%c-define-const x-gc-dash-list unsigned-long "GCDashList")
(%c-define-const x-gc-arc-mode unsigned-long "GCArcMode")

(define x-change-gc
  (c-lambda (Display*       ;; display
             GC             ;; gc
             unsigned-long  ;; valuemask
             XGCValues*)    ;; values
            int
            "XChangeGC"))

(define x-get-gc-values
  (c-lambda (Display*       ;; display
             GC             ;; gc
             unsigned-long  ;; valuemask
             XGCValues*)    ;; values_return
            int
            "XGetGCValues"))

(define x-query-font
  (c-lambda (Display*       ;; display
             Font)          ;; font_ID
            XFontStruct*/XFree
            "XQueryFont"))

(define x-load-font
  (c-lambda (Display*       ;; display
             char*)         ;; name
            Font
            "XLoadFont"))

(define x-load-query-font
  (c-lambda (Display*       ;; display
             char*)         ;; name
            XFontStruct*/XFree
            "XLoadQueryFont"))

(define x-font-struct-fid
  (c-lambda (XFontStruct*)  ;; font_struct
            Font
            "___result = ___arg1->fid;"))

(define x-font-struct-ascent
  (c-lambda (XFontStruct*)  ;; font_struct
            int
            "___result = ___arg1->ascent;"))

(define x-font-struct-descent
  (c-lambda (XFontStruct*)  ;; font_struct
            int
            "___result = ___arg1->descent;"))

(%c-define-const no-event-mask long "NoEventMask")
(%c-define-const key-press-mask long "KeyPressMask")
(%c-define-const key-release-mask long "KeyReleaseMask")
(%c-define-const button-press-mask long "ButtonPressMask")
(%c-define-const button-release-mask long "ButtonReleaseMask")
(%c-define-const enter-window-mask long "EnterWindowMask")
(%c-define-const leave-window-mask long "LeaveWindowMask")
(%c-define-const pointer-motion-mask long "PointerMotionMask")
(%c-define-const pointer-motion-hint-mask long "PointerMotionHintMask")
(%c-define-const button1-motion-mask long "Button1MotionMask")
(%c-define-const button2-motion-mask long "Button2MotionMask")
(%c-define-const button3-motion-mask long "Button3MotionMask")
(%c-define-const button4-motion-mask long "Button4MotionMask")
(%c-define-const button5-motion-mask long "Button5MotionMask")
(%c-define-const button-motion-mask long "ButtonMotionMask")
(%c-define-const keymap-state-mask long "KeymapStateMask")
(%c-define-const exposure-mask long "ExposureMask")
(%c-define-const visibility-change-mask long "VisibilityChangeMask")
(%c-define-const structure-notify-mask long "StructureNotifyMask")
(%c-define-const resize-redirect-mask long "ResizeRedirectMask")
(%c-define-const substructure-notify-mask long "SubstructureNotifyMask")
(%c-define-const substructure-redirect-mask long "SubstructureRedirectMask")
(%c-define-const focus-change-mask long "FocusChangeMask")
(%c-define-const property-change-mask long "PropertyChangeMask")
(%c-define-const colormap-change-mask long "ColormapChangeMask")
(%c-define-const owner-grab-button-mask long "OwnerGrabButtonMask")
(%c-define-const key-press long "KeyPress")
(%c-define-const key-release long "KeyRelease")
(%c-define-const button-press long "ButtonPress")
(%c-define-const button-release long "ButtonRelease")
(%c-define-const motion-notify long "MotionNotify")
(%c-define-const enter-notify long "EnterNotify")
(%c-define-const leave-notify long "LeaveNotify")
(%c-define-const focus-in long "FocusIn")
(%c-define-const focus-out long "FocusOut")
(%c-define-const keymap-notify long "KeymapNotify")
(%c-define-const expose long "Expose")
(%c-define-const graphics-expose long "GraphicsExpose")
(%c-define-const no-expose long "NoExpose")
(%c-define-const visibility-notify long "VisibilityNotify")
(%c-define-const create-notify long "CreateNotify")
(%c-define-const destroy-notify long "DestroyNotify")
(%c-define-const unmap-notify long "UnmapNotify")
(%c-define-const map-notify long "MapNotify")
(%c-define-const map-request long "MapRequest")
(%c-define-const reparent-notify long "ReparentNotify")
(%c-define-const configure-notify long "ConfigureNotify")
(%c-define-const configure-request long "ConfigureRequest")
(%c-define-const gravity-notify long "GravityNotify")
(%c-define-const resize-request long "ResizeRequest")
(%c-define-const circulate-notify long "CirculateNotify")
(%c-define-const circulate-request long "CirculateRequest")
(%c-define-const property-notify long "PropertyNotify")
(%c-define-const selection-clear long "SelectionClear")
(%c-define-const selection-request long "SelectionRequest")
(%c-define-const selection-notify long "SelectionNotify")
(%c-define-const colormap-notify long "ColormapNotify")
(%c-define-const client-message long "ClientMessage")
(%c-define-const mapping-notify long "MappingNotify")
(%c-define-const x-cw-event-mask long "CWEventMask")
(%c-define-const x-cw-cursor long "CWCursor")

(define x-pending
  (c-lambda (Display*)     ;; display
            int
            "XPending"))

(define x-check-mask-event
  (c-lambda (Display*       ;; display
            long)          ;; event_mask
            XEvent*/release-rc
            "
            XEvent ev;
            XEvent* pev;
            if (XCheckMaskEvent (___arg1, ___arg2, &ev))
            {
              pev = ___CAST(XEvent*,___EXT(___alloc_rc) (sizeof (ev)));
              *pev = ev;
            }
            else
              pev = 0;
            ___result_voidstar = pev;
            "))

(define x-next-event
	(c-lambda (Display*)       ;; display
						XEvent*/release-rc
						"
						XEvent ev;
						XEvent* pev;
						XNextEvent(___arg1, &ev);
						pev = ___CAST(XEvent*,___EXT(___alloc_rc) (sizeof (ev)));
						*pev = ev;
						___result_voidstar = pev;
						"
						))

(define x-select-input
  (c-lambda (Display*       ;; display
             Window         ;; w
             long)          ;; event_mask
            int
            "XSelectInput"))

(define x-lookup-string
  (c-lambda (XEvent*)      ;; event_struct (XKeyEvent)
            KeySym
#<<end-of-c-lambda
char buf[10];
KeySym ks;
XComposeStatus cs;
int n = XLookupString (___CAST(XKeyEvent*,___arg1),
                       buf,
                       sizeof (buf),
                       &ks,
                       &cs);
___result = ks;
end-of-c-lambda
))

(define x-get-window-attributes
	(c-lambda (Display* Window)
						XWindowAttributes*/release-rc
						"
						XWindowAttributes wa;
						XWindowAttributes *pwa;
						XGetWindowAttributes(___arg1, ___arg2, &wa);
						pwa = ___CAST(XWindowAttributes*, (___alloc_rc) (sizeof (wa)));
						*pwa = wa;
						___result_voidstar = pwa;
						"))

(define x-set-window-border-width
  (c-lambda (Display* Window unsigned-int)
            int
            "XSetWindowBorderWidth"))

(define x-set-window-border
  (c-lambda (Display* Window unsigned-long)
            int
            "XSetWindowBorder"))

(define x-move-resize-window
  (c-lambda (Display* Window int int unsigned-int unsigned-int)
            int
            "XMoveResizeWindow"))

(define x-move-window
  (c-lambda (Display* Window int int)
            int
            "XMoveWindow"))

(define x-resize-window
  (c-lambda (Display* Window unsigned-int unsigned-int)
            int
            "XResizeWindow"))

(define (%provided-mask v shift)
  (if (eq? v '())
      0
      (arithmetic-shift 1 shift)))

(define (%provided-value v default)
  (if (eq? v '())
      default
      v))

(%eval-when-load
	(define (%make-provided-mask args)
		(let loop ((args args)
							 (idx 0)
							 (acc '()))
			(if (pair? args)
					(let ((arg (car args)))
						(loop (cdr args)
									(+ idx 1)
									(cons `(%provided-mask ,(car arg) ,idx) acc)))
					acc))))

(%eval-when-load
	(define (%get-default-value arg)
		(if (null? (cddr arg))
				(case (cadr arg)
					((int unsigned-long unsigned-int Bool long) 0)
					((Window Pixmap Cursor Colormap) '+x-none+)
					(else (error (string-append "Cannot determine default type for "
																			(object->string (cadr arg))))))
				(caddr arg))))

(define-macro (%define/x-setter name args key-args type c-body)
  (let ((types (append (map cadr args) '(unsigned-long) (map cadr key-args)))
        (lambda-key-args (map (lambda (a) `(,(car a) '())) key-args))
        (mask-var (gensym)))
    `(define (,name ,@(map car args) #!key ,@lambda-key-args)
       (let ((,mask-var (bitwise-ior ,@(%make-provided-mask key-args))))
         ((c-lambda ,types ,type ,c-body)
          ,@(map car args)
          ,mask-var
          ,@(map (lambda (a)
                   `(%provided-value ,(car a) ,(%get-default-value a)))
                 key-args))))))

(%define/x-setter x-configure-window
									((display Display*)
									 (window Window))
									((x int)
									 (y int)
									 (width int)
									 (height int)
									 (border-width int)
									 (sibling Window)
									 (stack-mode int))
									int
									"								
									XWindowChanges wc;
									wc.x = ___arg4;
									wc.y = ___arg5;
									wc.width = ___arg6;
									wc.height = ___arg7;
									wc.border_width = ___arg8;
									wc.sibling = ___arg9;
									wc.stack_mode = ___arg10;
									___result = XConfigureWindow(___arg1, ___arg2, ___arg3, &wc);
									")

(%define/x-setter x-change-window-attributes
									((display Display*)
									 (window Window))
									((background-pixmap Pixmap)
									 (background-pixel unsigned-long)
									 (border-pixmap Pixmap)
									 (border-pixel unsigned-long)
									 (bit-gravity int)
									 (win-gravity int)
									 (backing-store int)
									 (backing-planes unsigned-long)
									 (backing-pixel unsigned-long)
									 (save-under Bool)
									 (event-mask long)
									 (do-not-propagate-mask long)
									 (override-redirect Bool)
									 (colormap Colormap)
									 (cursor Cursor))
									int
									"
									XSetWindowAttributes wa;
									wa.background_pixmap = ___arg4;
									wa.background_pixel = ___arg5;
									wa.border_pixmap = ___arg6;
									wa.border_pixel = ___arg7;
									wa.bit_gravity = ___arg8;
									wa.win_gravity = ___arg9;
									wa.backing_store = ___arg10;
									wa.backing_planes = ___arg11;
									wa.backing_pixel = ___arg12;
									wa.save_under = ___arg13;
									wa.event_mask = ___arg14;
									wa.do_not_propagate_mask = ___arg15;
									wa.override_redirect = ___arg16;
									wa.colormap = ___arg17;
									wa.cursor = ___arg18;
									___result = XChangeWindowAttributes(___arg1,
																											 ___arg2,
																											 ___arg3,
																											 &wa);
									")

(define (convert-x-event ev)
  (and ev
       (let ((type (x-any-event-type ev)))
         (cond ((or (##fixnum.= type key-press)
                    (##fixnum.= type key-release))
                (##list
                 (if (##fixnum.= type key-press)
                     'x-key-pressed-event
                     'x-key-released-event)
                 type
                 (x-any-event-serial ev)
                 (x-any-event-send-event ev)
                 (x-any-event-display ev)
                 (x-any-event-window ev)
                 (x-key-event-root ev)
                 (x-key-event-subwindow ev)
                 (x-key-event-time ev)
                 (x-key-event-x ev)
                 (x-key-event-y ev)
                 (x-key-event-x-root ev)
                 (x-key-event-y-root ev)
                 (x-key-event-state ev)
                 (x-key-event-keycode ev)
                 (x-key-event-same-screen ev)
                 (x-lookup-string ev)))
               ((or (##fixnum.= type button-press)
                    (##fixnum.= type button-release))
                (##list
                 (if (##fixnum.= type button-press)
                     'x-button-pressed-event
                     'x-button-released-event)
                 type
                 (x-any-event-serial ev)
                 (x-any-event-send-event ev)
                 (x-any-event-display ev)
                 (x-any-event-window ev)
                 (x-button-event-root ev)
                 (x-button-event-subwindow ev)
                 (x-button-event-time ev)
                 (x-button-event-x ev)
                 (x-button-event-y ev)
                 (x-button-event-x-root ev)
                 (x-button-event-y-root ev)
                 (x-button-event-state ev)
                 (x-button-event-button ev)
                 (x-button-event-same-screen ev)))
               ((##fixnum.= type motion-notify)
                (##list
                 'x-pointer-moved-event
                 type
                 (x-any-event-serial ev)
                 (x-any-event-send-event ev)
                 (x-any-event-display ev)
                 (x-any-event-window ev)
                 (x-motion-event-root ev)
                 (x-motion-event-subwindow ev)
                 (x-motion-event-time ev)
                 (x-motion-event-x ev)
                 (x-motion-event-y ev)
                 (x-motion-event-x-root ev)
                 (x-motion-event-y-root ev)
                 (x-motion-event-state ev)
                 (x-motion-event-is-hint ev)
                 (x-motion-event-same-screen ev)))
               ((or (##fixnum.= type enter-notify)
                    (##fixnum.= type leave-notify))
                (##list
                 (if (##fixnum.= type enter-notify)
                     'x-enter-window-event
                     'x-leave-window-event)
                 type
                 (x-any-event-serial ev)
                 (x-any-event-send-event ev)
                 (x-any-event-display ev)
                 (x-any-event-window ev)
                 (x-crossing-event-root ev)
                 (x-crossing-event-subwindow ev)
                 (x-crossing-event-time ev)
                 (x-crossing-event-x ev)
                 (x-crossing-event-y ev)
                 (x-crossing-event-x-root ev)
                 (x-crossing-event-y-root ev)
                 (x-crossing-event-mode ev)
                 (x-crossing-event-detail ev)
                 (x-crossing-event-same-screen ev)
                 (x-crossing-event-focus ev)
                 (x-crossing-event-state ev)))
               (else
                #f)))))

(define (wait-x11-event x11-display)
  (let* ((x11-display-fd (x-connection-number x11-display))
         (x11-display-port (##open-predefined 1
                                              '(X11-display)
                                              x11-display-fd)))
    (##device-port-wait-for-input! x11-display-port)))
;;;============================================================================
