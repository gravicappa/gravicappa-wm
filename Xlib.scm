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
  (not safe)
)

;;;============================================================================

(c-declare #<<end-of-c-declare

#include <X11/Xlib.h>
#include <X11/Xutil.h>

end-of-c-declare
)

;; Declare a few types so that the function prototypes use the same
;; type names as a C program.

(c-define-type Time unsigned-long)
(c-define-type XID unsigned-long)

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

___SCMOBJ XFree_Visual( void* ptr )
{ Visual* p = ptr;
#ifdef debug_free
  printf( "XFree_Visual(%p)\n", p );
  fflush( stdout );
#endif
#ifdef really_free
  XFree( p );
#endif
  return ___FIX(___NO_ERR);
}

___SCMOBJ XFree_Display( void* ptr )
{ Display* p = ptr;
#ifdef debug_free
  printf( "XFree_Display(%p)\n", p );
  fflush( stdout );
#endif
#ifdef really_free
  XFree( p );
#endif
  return ___FIX(___NO_ERR);
}

___SCMOBJ XFree_Screen( void* ptr )
{ Screen* p = ptr;
#ifdef debug_free
  printf( "XFree_Screen(%p)\n", p );
  fflush( stdout );
#endif
#ifdef really_free
  XFree( p );
#endif
  return ___FIX(___NO_ERR);
}

___SCMOBJ release_rc_XGCValues( void* ptr )
{ XGCValues* p = ptr;
#ifdef debug_free
  printf( "release_rc_XGCValues(%p)\n", p );
  fflush( stdout );
#endif
#ifdef really_free
  ___EXT(___release_rc)( p );
#endif
  return ___FIX(___NO_ERR);
}

___SCMOBJ XFree_XFontStruct( void* ptr )
{ XFontStruct* p = ptr;
#ifdef debug_free
  printf( "XFree_XFontStruct(%p)\n", p );
  fflush( stdout );
#endif
#ifdef really_free
  XFree( p );
#endif
  return ___FIX(___NO_ERR);
}

___SCMOBJ release_rc_XColor( void* ptr )
{ XColor* p = ptr;
#ifdef debug_free
  printf( "release_rc_XColor(%p)\n", p );
  fflush( stdout );
#endif
#ifdef really_free
  ___EXT(___release_rc)( p );
#endif
  return ___FIX(___NO_ERR);
}

___SCMOBJ release_rc_XEvent( void* ptr )
{ XEvent* p = ptr;
#ifdef debug_free
  printf( "release_rc_XEvent(%p)\n", p );
  fflush( stdout );
#endif
#ifdef really_free
  ___EXT(___release_rc)( p );
#endif
  return ___FIX(___NO_ERR);
}

end-of-c-declare
)

(c-define-type Bool int)
(c-define-type Status int)
(c-define-type GC (pointer (struct "_XGC") (GC)))
(c-define-type GC/XFree (pointer (struct "_XGC") (GC) "XFree_GC"))
(c-define-type Visual "Visual")
(c-define-type Visual* (pointer Visual (Visual*)))
(c-define-type Visual*/XFree (pointer Visual (Visual*) "XFree_Visual"))
(c-define-type Display "Display")
(c-define-type Display* (pointer Display (Display*)))
(c-define-type Display*/XFree (pointer Display (Display*) "XFree_Display"))
(c-define-type Screen "Screen")
(c-define-type Screen* (pointer Screen (Screen*)))
(c-define-type Screen*/XFree (pointer Screen (Screen*) "XFree_Screen"))
(c-define-type XGCValues "XGCValues")
(c-define-type XGCValues* (pointer XGCValues (XGCValues*)))
(c-define-type XGCValues*/release-rc (pointer XGCValues (XGCValues*) "release_rc_XGCValues"))
(c-define-type XFontStruct "XFontStruct")
(c-define-type XFontStruct* (pointer XFontStruct (XFontStruct*)))
(c-define-type XFontStruct*/XFree (pointer XFontStruct (XFontStruct*) "XFree_XFontStruct"))
(c-define-type XColor "XColor")
(c-define-type XColor* (pointer XColor (XColor*)))
(c-define-type XColor*/release-rc (pointer XColor (XColor*) "release_rc_XColor"))
(c-define-type XEvent "XEvent")
(c-define-type XEvent* (pointer XEvent (XEvent*)))
(c-define-type XEvent*/release-rc (pointer XEvent (XEvent*) "release_rc_XEvent"))

(c-define-type char* char-string)

;; Function prototypes for a minimal subset of Xlib functions.  The
;; functions have the same name in Scheme and C.

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

(define (make--x-color-box)
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

(define x-gc-function
  ((c-lambda () unsigned-long "___result = GCFunction;")))

(define x-gc-plane-mask
  ((c-lambda () unsigned-long "___result = GCPlaneMask;")))

(define x-gc-foreground
  ((c-lambda () unsigned-long "___result = GCForeground;")))

(define x-gc-background
  ((c-lambda () unsigned-long "___result = GCBackground;")))

(define x-gc-line-width
  ((c-lambda () unsigned-long "___result = GCLineWidth;")))

(define x-gc-line-style
  ((c-lambda () unsigned-long "___result = GCLineStyle;")))

(define x-gc-cap-style
  ((c-lambda () unsigned-long "___result = GCCapStyle;")))

(define x-gc-join-style
  ((c-lambda () unsigned-long "___result = GCJoinStyle;")))

(define x-gc-fill-style
  ((c-lambda () unsigned-long "___result = GCFillStyle;")))

(define x-gc-fill-rule
  ((c-lambda () unsigned-long "___result = GCFillRule;")))

(define x-gc-tile
  ((c-lambda () unsigned-long "___result = GCTile;")))

(define x-gc-stipple
  ((c-lambda () unsigned-long "___result = GCStipple;")))

(define x-gc-tile-stip-x-origin
  ((c-lambda () unsigned-long "___result = GCTileStipXOrigin;")))

(define x-gc-tile-stip-y-origin
  ((c-lambda () unsigned-long "___result = GCTileStipYOrigin;")))

(define x-gc-font
  ((c-lambda () unsigned-long "___result = GCFont;")))

(define x-gc-subwindow-mode
  ((c-lambda () unsigned-long "___result = GCSubwindowMode;")))

(define x-gc-graphics-exposures
  ((c-lambda () unsigned-long "___result = GCGraphicsExposures;")))

(define x-gc-clip-x-origin
  ((c-lambda () unsigned-long "___result = GCClipXOrigin;")))

(define x-gc-clip-y-origin
  ((c-lambda () unsigned-long "___result = GCClipYOrigin;")))

(define x-gc-clip-mask
  ((c-lambda () unsigned-long "___result = GCClipMask;")))

(define x-gc-dash-offset
  ((c-lambda () unsigned-long "___result = GCDashOffset;")))

(define x-gc-dash-list
  ((c-lambda () unsigned-long "___result = GCDashList;")))

(define x-gc-arc-mode
  ((c-lambda () unsigned-long "___result = GCArcMode;")))

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

(define +x-none+
  ((c-lambda () unsigned-long "___result = None;")))

(define no-event-mask
  ((c-lambda () long "___result = NoEventMask;")))

(define key-press-mask
  ((c-lambda () long "___result = KeyPressMask;")))

(define key-release-mask
  ((c-lambda () long "___result = KeyReleaseMask;")))

(define button-press-mask
  ((c-lambda () long "___result = ButtonPressMask;")))

(define button-release-mask
  ((c-lambda () long "___result = ButtonReleaseMask;")))

(define enter-window-mask
  ((c-lambda () long "___result = EnterWindowMask;")))

(define leave-window-mask
  ((c-lambda () long "___result = LeaveWindowMask;")))

(define pointer-motion-mask
  ((c-lambda () long "___result = PointerMotionMask;")))

(define pointer-motion-hint-mask
  ((c-lambda () long "___result = PointerMotionHintMask;")))

(define button1-motion-mask
  ((c-lambda () long "___result = Button1MotionMask;")))

(define button2-motion-mask
  ((c-lambda () long "___result = Button2MotionMask;")))

(define button3-motion-mask
  ((c-lambda () long "___result = Button3MotionMask;")))

(define button4-motion-mask
  ((c-lambda () long "___result = Button4MotionMask;")))

(define button5-motion-mask
  ((c-lambda () long "___result = Button5MotionMask;")))

(define button-motion-mask
  ((c-lambda () long "___result = ButtonMotionMask;")))

(define keymap-state-mask
  ((c-lambda () long "___result = KeymapStateMask;")))

(define exposure-mask
  ((c-lambda () long "___result = ExposureMask;")))

(define visibility-change-mask
  ((c-lambda () long "___result = VisibilityChangeMask;")))

(define structure-notify-mask
  ((c-lambda () long "___result = StructureNotifyMask;")))

(define resize-redirect-mask
  ((c-lambda () long "___result = ResizeRedirectMask;")))

(define substructure-notify-mask
  ((c-lambda () long "___result = SubstructureNotifyMask;")))

(define substructure-redirect-mask
  ((c-lambda () long "___result = SubstructureRedirectMask;")))

(define focus-change-mask
  ((c-lambda () long "___result = FocusChangeMask;")))

(define property-change-mask
  ((c-lambda () long "___result = PropertyChangeMask;")))

(define colormap-change-mask
  ((c-lambda () long "___result = ColormapChangeMask;")))

(define owner-grab-button-mask
  ((c-lambda () long "___result = OwnerGrabButtonMask;")))

(define key-press
  ((c-lambda () long "___result = KeyPress;")))

(define key-release
  ((c-lambda () long "___result = KeyRelease;")))

(define button-press
  ((c-lambda () long "___result = ButtonPress;")))

(define button-release
  ((c-lambda () long "___result = ButtonRelease;")))

(define motion-notify
  ((c-lambda () long "___result = MotionNotify;")))

(define enter-notify
  ((c-lambda () long "___result = EnterNotify;")))

(define leave-notify
  ((c-lambda () long "___result = LeaveNotify;")))

(define focus-in
  ((c-lambda () long "___result = FocusIn;")))

(define focus-out
  ((c-lambda () long "___result = FocusOut;")))

(define keymap-notify
  ((c-lambda () long "___result = KeymapNotify;")))

(define expose
  ((c-lambda () long "___result = Expose;")))

(define graphics-expose
  ((c-lambda () long "___result = GraphicsExpose;")))

(define no-expose
  ((c-lambda () long "___result = NoExpose;")))

(define visibility-notify
  ((c-lambda () long "___result = VisibilityNotify;")))

(define create-notify
  ((c-lambda () long "___result = CreateNotify;")))

(define destroy-notify
  ((c-lambda () long "___result = DestroyNotify;")))

(define unmap-notify
  ((c-lambda () long "___result = UnmapNotify;")))

(define map-notify
  ((c-lambda () long "___result = MapNotify;")))

(define map-request
  ((c-lambda () long "___result = MapRequest;")))

(define reparent-notify
  ((c-lambda () long "___result = ReparentNotify;")))

(define configure-notify
  ((c-lambda () long "___result = ConfigureNotify;")))

(define configure-request
  ((c-lambda () long "___result = ConfigureRequest;")))

(define gravity-notify
  ((c-lambda () long "___result = GravityNotify;")))

(define resize-request
  ((c-lambda () long "___result = ResizeRequest;")))

(define circulate-notify
  ((c-lambda () long "___result = CirculateNotify;")))

(define circulate-request
  ((c-lambda () long "___result = CirculateRequest;")))

(define property-notify
  ((c-lambda () long "___result = PropertyNotify;")))

(define selection-clear
  ((c-lambda () long "___result = SelectionClear;")))

(define selection-request
  ((c-lambda () long "___result = SelectionRequest;")))

(define selection-notify
  ((c-lambda () long "___result = SelectionNotify;")))

(define colormap-notify
  ((c-lambda () long "___result = ColormapNotify;")))

(define client-message
  ((c-lambda () long "___result = ClientMessage;")))

(define mapping-notify
  ((c-lambda () long "___result = MappingNotify;")))

(define x-cw-event-mask
  (c-lambda () long "___result = CWEventMask;"))

(define x-cw-cursor
  (c-lambda () long "___result = CWCursor;"))

(define x-change-window-attributes
  (c-lambda (Display* Window unsigned-long )
            "XChangeWindowAttributes"))

(define x-pending
  (c-lambda (Display*)     ;; display
            int
            "XPending"))

(define x-check-mask-event
  (c-lambda (Display*       ;; display
             long)          ;; event_mask
            XEvent*/release-rc
#<<end-of-c-lambda
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
end-of-c-lambda
))

(define x-next-event
  (c-lambda (Display*)       ;; display
            XEvent*/release-rc
#<<end-of-c-lambda
XEvent ev;
XEvent* pev;
if (1 || XNextEvent(___arg1, &ev) == 0)
  {
    pev = ___CAST(XEvent*,___EXT(___alloc_rc) (sizeof (ev)));
    *pev = ev;
  }
else
  pev = 0;
___result_voidstar = pev;
end-of-c-lambda
))

(define x-select-input
  (c-lambda (Display*       ;; display
             Window         ;; w
             long)          ;; event_mask
            int
            "XSelectInput"))

(define x-any-event-type
  (c-lambda (XEvent*)       ;; XEvent box
            int
            "___result = ___arg1->type;"))

(define x-any-event-serial
  (c-lambda (XEvent*)       ;; XEvent box
            unsigned-long
            "___result = ___arg1->xany.serial;"))

(define x-any-event-send-event
  (c-lambda (XEvent*)       ;; XEvent box
            bool
            "___result = ___arg1->xany.send_event;"))

(define x-any-event-display
  (c-lambda (XEvent*)       ;; XEvent box
            Display*
            "___result_voidstar = ___arg1->xany.display;"))

(define x-any-event-window
  (c-lambda (XEvent*)       ;; XEvent box
            Window
            "___result = ___arg1->xany.window;"))

(define x-key-event-root
  (c-lambda (XEvent*)       ;; XEvent box
            Window
            "___result = ___arg1->xkey.root;"))

(define x-key-event-subwindow
  (c-lambda (XEvent*)       ;; XEvent box
            Window
            "___result = ___arg1->xkey.subwindow;"))

(define x-key-event-time
  (c-lambda (XEvent*)       ;; XEvent box
            Time
            "___result = ___arg1->xkey.time;"))

(define x-key-event-x
  (c-lambda (XEvent*)       ;; XEvent box
            int
            "___result = ___arg1->xkey.x;"))

(define x-key-event-y
  (c-lambda (XEvent*)       ;; XEvent box
            int
            "___result = ___arg1->xkey.y;"))

(define x-key-event-x-root
  (c-lambda (XEvent*)       ;; XEvent box
            int
            "___result = ___arg1->xkey.x_root;"))

(define x-key-event-y-root
  (c-lambda (XEvent*)       ;; XEvent box
            int
            "___result = ___arg1->xkey.y_root;"))

(define x-key-event-state
  (c-lambda (XEvent*)       ;; XEvent box
            unsigned-int
            "___result = ___arg1->xkey.state;"))

(define x-key-event-keycode
  (c-lambda (XEvent*)       ;; XEvent box
            unsigned-int
            "___result = ___arg1->xkey.keycode;"))

(define x-key-event-same-screen
  (c-lambda (XEvent*)       ;; XEvent box
            bool
            "___result = ___arg1->xkey.same_screen;"))

(define x-button-event-root
  (c-lambda (XEvent*)       ;; XEvent box
            Window
            "___result = ___arg1->xbutton.root;"))

(define x-button-event-subwindow
  (c-lambda (XEvent*)       ;; XEvent box
            Window
            "___result = ___arg1->xbutton.subwindow;"))

(define x-button-event-time
  (c-lambda (XEvent*)       ;; XEvent box
            Time
            "___result = ___arg1->xbutton.time;"))

(define x-button-event-x
  (c-lambda (XEvent*)       ;; XEvent box
            int
            "___result = ___arg1->xbutton.x;"))

(define x-button-event-y
  (c-lambda (XEvent*)       ;; XEvent box
            int
            "___result = ___arg1->xbutton.y;"))

(define x-button-event-x-root
  (c-lambda (XEvent*)       ;; XEvent box
            int
            "___result = ___arg1->xbutton.x_root;"))

(define x-button-event-y-root
  (c-lambda (XEvent*)       ;; XEvent box
            int
            "___result = ___arg1->xbutton.y_root;"))

(define x-button-event-state
  (c-lambda (XEvent*)       ;; XEvent box
            unsigned-int
            "___result = ___arg1->xbutton.state;"))

(define x-button-event-button
  (c-lambda (XEvent*)       ;; XEvent box
            unsigned-int
            "___result = ___arg1->xbutton.button;"))

(define x-button-event-same-screen
  (c-lambda (XEvent*)       ;; XEvent box
            bool
            "___result = ___arg1->xbutton.same_screen;"))

(define x-motion-event-root
  (c-lambda (XEvent*)       ;; XEvent box
            Window
            "___result = ___arg1->xmotion.root;"))

(define x-motion-event-subwindow
  (c-lambda (XEvent*)       ;; XEvent box
            Window
            "___result = ___arg1->xmotion.subwindow;"))

(define x-motion-event-time
  (c-lambda (XEvent*)       ;; XEvent box
            Time
            "___result = ___arg1->xmotion.time;"))

(define x-motion-event-x
  (c-lambda (XEvent*)       ;; XEvent box
            int
            "___result = ___arg1->xmotion.x;"))

(define x-motion-event-y
  (c-lambda (XEvent*)       ;; XEvent box
            int
            "___result = ___arg1->xmotion.y;"))

(define x-motion-event-x-root
  (c-lambda (XEvent*)       ;; XEvent box
            int
            "___result = ___arg1->xmotion.x_root;"))

(define x-motion-event-y-root
  (c-lambda (XEvent*)       ;; XEvent box
            int
            "___result = ___arg1->xmotion.y_root;"))

(define x-motion-event-state
  (c-lambda (XEvent*)       ;; XEvent box
            unsigned-int
            "___result = ___arg1->xmotion.state;"))

(define x-motion-event-is-hint
  (c-lambda (XEvent*)       ;; XEvent box
            char
            "___result = ___arg1->xmotion.is_hint;"))

(define x-motion-event-same-screen
  (c-lambda (XEvent*)       ;; XEvent box
            bool
            "___result = ___arg1->xmotion.same_screen;"))

(define x-crossing-event-root
  (c-lambda (XEvent*)       ;; XEvent box
            Window
            "___result = ___arg1->xcrossing.root;"))

(define x-crossing-event-subwindow
  (c-lambda (XEvent*)       ;; XEvent box
            Window
            "___result = ___arg1->xcrossing.subwindow;"))

(define x-crossing-event-time
  (c-lambda (XEvent*)       ;; XEvent box
            Time
            "___result = ___arg1->xcrossing.time;"))

(define x-crossing-event-x
  (c-lambda (XEvent*)       ;; XEvent box
            int
            "___result = ___arg1->xcrossing.x;"))

(define x-crossing-event-y
  (c-lambda (XEvent*)       ;; XEvent box
            int
            "___result = ___arg1->xcrossing.y;"))

(define x-crossing-event-x-root
  (c-lambda (XEvent*)       ;; XEvent box
            int
            "___result = ___arg1->xcrossing.x_root;"))

(define x-crossing-event-y-root
  (c-lambda (XEvent*)       ;; XEvent box
            int
            "___result = ___arg1->xcrossing.y_root;"))

(define x-crossing-event-mode
  (c-lambda (XEvent*)       ;; XEvent box
            int
            "___result = ___arg1->xcrossing.mode;"))

(define x-crossing-event-detail
  (c-lambda (XEvent*)       ;; XEvent box
            int
            "___result = ___arg1->xcrossing.detail;"))

(define x-crossing-event-same-screen
  (c-lambda (XEvent*)       ;; XEvent box
            bool
            "___result = ___arg1->xcrossing.same_screen;"))

(define x-crossing-event-focus
  (c-lambda (XEvent*)       ;; XEvent box
            bool
            "___result = ___arg1->xcrossing.focus;"))

(define x-crossing-event-state
  (c-lambda (XEvent*)       ;; XEvent box
            unsigned-int
            "___result = ___arg1->xcrossing.state;"))

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

(define (%make-provided-mask args)
  (let loop ((args args)
             (idx 0)
             (acc '()))
    (if (pair? args)
        (let ((arg (car args)))
          (loop (cdr args) 
                (+ idx 1) 
                (cons `(%provided-mask ,(car arg) ,idx) acc)))
        acc)))

(define (%get-default-value arg)
  (if (null? (cddr arg))
      (case (cadr arg)
        ((int) 0)
        ((Window Pixmap) +x-none+))
      (caddr arg)))

(define-macro (define/x-setter name args key-args type c-body)
  (let ((types (map cadr key-args))
        (lambda-key-args (map (lambda (a) (list (car args '()))) key-args))
        (mask-var (gensym)))
    `(define (,name args #!key ,@lambda-key-args)
       (let ((,mask-var (bitwise-ior ,@(%make-provided-mask key-args))))
         ((c-lambda ,types ,type ,c-body)
          ,@args 
          ,mask-var 
          ,@(map (lambda (a) 
                   `(%provided-value ,(car a) ,(%get-default-value a)))
                 key-args))))))

(define/x-setter x-configure-window 
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
#<<end-of-c-lambda
  XWindowChanges wc;
  wc.x = __arg4;
  wc.y = __arg5;
  wc.width = __arg6;
  wc.height = __arg7;
  wc.border_width = __arg8;
  wc.sibling = __arg9;
  wc.stack_mode = __arg10;
  ___result = XConfigureWindow(__arg1, __arg2, __arg3, &wc);
end-of-c-lambda)

(define/x-setter x-change-window-attributes 
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
#<<end-of-c-lambda
  XSetWindowAttributes wa;
  wa.background_pixmap = __arg4;
  wa.background_pixel = __arg5;
  wa.border_pixmap = __arg6;
  wa.border_pixel = __arg7;
  wa.bit_gravity = __arg8;
  wa.win_gravity = __arg9;
  wa.backing_store = __arg10;
  wa.backing_planes = __arg11;
  wa.backing_pixel = __arg12;
  wa.save_under = __arg13;
  wa.event_mask = __arg14;
  wa.do_not_propagate_mask = __arg15;
  wa.override_redirect = __arg16;
  wa.colormap = __arg17;
  wa.cursor = __arg18;
  ___result = XChangeWindowAttributes(__arg1, __arg2, __arg3, &wa);
end-of-c-lambda)

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
