(declare
  (standard-bindings)
  (extended-bindings)
  (block)
  (not safe))

(c-declare "
#include <stdlib.h>
#include <stdio.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xatom.h>
#include <X11/Xproto.h>
#include <X11/keysym.h>

#define XLIB_SCM_DBG_ALLOC_REPORT 0

#define XLIB_SCM_ALLOC_OBJ(var, type) \
  do { \
    var = ___CAST(type *, ___EXT(___alloc_rc)(sizeof(type))); \
    if (XLIB_SCM_DBG_ALLOC_REPORT) \
      fprintf(stderr, \";;; (alloc \\\"%s\\\" \\\"%p\\\")\\n\", #type, var); \
  } while (0);

")

;; Declare a few types so that the function prototypes use the same
;; type names as a C program.

(c-define-type char* char-string)
(c-define-type Time unsigned-long)
(c-define-type XID unsigned-long)
(c-define-type Atom unsigned-long)

(c-define-type Bool bool)
(c-define-type Status int)

(c-define-type Window XID)
(c-define-type Drawable XID)
(c-define-type Font XID)
(c-define-type Pixmap XID)
(c-define-type Cursor XID)
(c-define-type Colormap XID)
(c-define-type GContext XID)
(c-define-type KeySym XID)
(c-define-type KeyCode unsigned-char)

(c-declare #<<end-of-c-declare

#define debug_free_not

#ifdef debug_free
#include <stdio.h>
#endif

___SCMOBJ
XFree_GC(void *ptr)
{
  GC p = ptr;
#ifdef debug_free
  printf("XFree_GC(%p)\n", p);
  fflush(stdout);
#endif
  XFree(p);
  return ___FIX(___NO_ERR);
}

end-of-c-declare
)

(include "ffi.scm")

(extern-object-releaser-set! "XFree" "XFree(p);\n")

(c-define-type Display* (pointer "Display"))
(c-define-type GC (pointer (struct "_XGC") (GC)))
(c-define-type GC/XFree (pointer (struct "_XGC") (GC) "XFree_GC"))

(ffi-define-type "XGCValues" "release-rc")
(ffi-define-type "XColor" "release-rc")
(ffi-define-type "Visual" "XFree")
(ffi-define-type "Screen" "XFree")
(ffi-define-type "XFontStruct" "XFree")
(ffi-define-type "XWindowAttributes" "release-rc")
(ffi-define-type "XSizeHints" "release-rc")
(ffi-define-type "XEvent" "release-rc")

(c-define-type XAnyEvent* XEvent*)
(c-define-type XKeyEvent* XEvent*)
(c-define-type XButtonEvent* XEvent*)
(c-define-type XMotionEvent* XEvent*)
(c-define-type XCrossingEvent* XEvent*)
(c-define-type XFocusChangeEvent* XEvent*)
(c-define-type XExposeEvent* XEvent*)
(c-define-type XGraphicsExposeEvent* XEvent*)
(c-define-type XNoExposeEvent* XEvent*)
(c-define-type XVisibilityEvent* XEvent*)
(c-define-type XCreateWindowEvent* XEvent*)
(c-define-type XDestroyWindowEvent* XEvent*)
(c-define-type XUnmapEvent* XEvent*)
(c-define-type XMapEvent* XEvent*)
(c-define-type XMapRequestEvent* XEvent*)
(c-define-type XReparentEvent* XEvent*)
(c-define-type XConfigureEvent* XEvent*)
(c-define-type XGravityEvent* XEvent*)
(c-define-type XResizeRequestEvent* XEvent*)
(c-define-type XConfigureRequestEvent* XEvent*)
(c-define-type XCirculateEvent* XEvent*)
(c-define-type XCirculateRequestEvent* XEvent*)
(c-define-type XPropertyEvent* XEvent*)
(c-define-type XSelectionClearEvent* XEvent*)
(c-define-type XSelectionRequestEvent* XEvent*)
(c-define-type XSelectionEvent* XEvent*)
(c-define-type XColormapEvent* XEvent*)
(c-define-type XClientMessageEvent* XEvent*)
(c-define-type XMappingEvent* XEvent*)
(c-define-type XErrorEvent* XEvent*)
(c-define-type XKeymapEvent* XEvent*)

(include "xlib-structs.scm")
(include "xlib-constants.scm")

(define (x-client-message-event-data-l ev)
  (let ((obj (make-u32vector 5)))
    ((c-lambda (XClientMessageEvent* scheme-object) void
               "
                 long i, x;
                 XClientMessageEvent *cme = &___arg1->xclient;
                 for (i = 0; i < 5; ++i) {
                   x = ___FIX((___CAST(___U32, cme->data.l[i])));
                   ___U32VECTORSET(___arg2, ___FIX(i), x);
                 }
               ")
     ev obj)
    obj))

(define x-size-hints-min-aspect-x
  (c-lambda (XSizeHints*) int "___result = ___arg1->min_aspect.x;"))

(define x-size-hints-min-aspect-y
  (c-lambda (XSizeHints*) int "___result = ___arg1->min_aspect.y;"))

(define x-size-hints-max-aspect-x
  (c-lambda (XSizeHints*) int "___result = ___arg1->max_aspect.x;"))

(define x-size-hints-max-aspect-y
  (c-lambda (XSizeHints*) int "___result = ___arg1->max_aspect.y;"))

(define set-x-size-hints-min-aspect-x!
  (c-lambda (XSizeHints* int) void "___arg1->min_aspect.x = ___arg2;"))

(define set-x-size-hints-min-aspect-y!
  (c-lambda (XSizeHints* int) void "___arg1->min_aspect.y = ___arg2;"))

(define set-x-size-hints-max-aspect-x!
  (c-lambda (XSizeHints* int) void "___arg1->max_aspect.x = ___arg2;"))

(define set-x-size-hints-max-aspect-y!
  (c-lambda (XSizeHints* int) void "___arg1->max_aspect.y = ___arg2;"))

(define (x-default-error-handler display ev)
  (let ((request-code (char->integer (x-error-event-request-code ev)))
        (error-code (char->integer (x-error-event-error-code ev))))
    (error (string-append "Xlib: error request-code:"
                          (number->string request-code)
                          " error-code: "
                          (number->string error-code)))))

(define x-error-handler x-default-error-handler)

(c-define (x-scheme-error-handler display ev)
          (Display* XErrorEvent*)
          int
          "scheme_x_error_handler"
          ""
          (error-handler display ev)
          0)

(define x#%set-error-handler!
  (c-lambda ((function (Display* XErrorEvent*) int))
            (pointer "void")
            "___result_voidstar = XSetErrorHandler((XErrorHandler)___arg1);"))

(define (set-x-error-handler! fn)
  (set! error-handler fn)
  (x#%set-error-handler! x-scheme-error-handler)
  (void))

(define x-size-hints-min-aspect-x
  (c-lambda (XSizeHints*) int "___result = ___arg1->min_aspect.x;"))

(define x-size-hints-min-aspect-y
  (c-lambda (XSizeHints*) int "___result = ___arg1->min_aspect.y;"))

(define x-size-hints-max-aspect-x
  (c-lambda (XSizeHints*) int "___result = ___arg1->max_aspect.x;"))

(define x-size-hints-max-aspect-y
  (c-lambda (XSizeHints*) int "___result = ___arg1->max_aspect.y;"))

(define (x-open-display name)
  (let ((d ((c-lambda (char*) Display* "XOpenDisplay") name)))
    (make-will d x-close-display)
    d))

(define x-close-display
  (c-lambda (Display*) int "XCloseDisplay"))

(define x-grab-server
  (c-lambda (Display*) int "XGrabServer"))

(define x-ungrab-server
  (c-lambda (Display*) int "XUngrabServer"))

(define x-display-width
  (c-lambda (Display* int) int "DisplayWidth"))

(define x-display-height
  (c-lambda (Display* int) int "DisplayHeight"))

(define x-default-screen
  (c-lambda (Display*) int "XDefaultScreen"))

(define x-screen-count
  (c-lambda (Display*) int "ScreenCount"))

(define x-screen-of-display
  (c-lambda (Display* int) Screen* "XScreenOfDisplay"))

(define x-default-colormap-of-screen
  (c-lambda (Screen*) Colormap "XDefaultColormapOfScreen"))

(define x-default-colormap
  (c-lambda (Display* int) Colormap "XDefaultColormap"))

(define x-clear-window
  (c-lambda (Display* Window) int "XClearWindow"))

(define x-connection-number
  (c-lambda (Display*) int "XConnectionNumber"))

(define x-root-window
  (c-lambda (Display* int) Window "XRootWindow"))

(define x-default-root-window
  (c-lambda (Display*) Window "XDefaultRootWindow"))

(define x-root-window-of-screen
  (c-lambda (Screen*) Window "XRootWindowOfScreen"))

(define x-default-visual
  (c-lambda (Display* int) Visual*/XFree "XDefaultVisual"))

(define x-default-visual-of-screen
  (c-lambda (Screen*) Visual*/XFree "XDefaultVisualOfScreen"))

(define x-intern-atom
  (c-lambda (Display* char-string Bool) Atom "XInternAtom"))

(define x-get-atom-name
  (c-lambda (Display* Atom) scheme-object
  "
   char *s;
   ___SCMOBJ ret;

   s = XGetAtomName(___arg1, ___arg2);
   ___result = ___NUL;
   if (s) {
     ___EXT(___CHARSTRING_to_SCMOBJ)(___PSTATE, s, &ret, 0);
     XFree(s);
     ___release_scmobj(ret);
     ___result = ret;
   }
  "))

(define x-default-gc
  (c-lambda (Display* int) GC/XFree "XDefaultGC"))

(define x-default-gc-of-screen
  (c-lambda (Screen*) GC/XFree "XDefaultGCOfScreen"))

(define x-black-pixel
  (c-lambda (Display* int) unsigned-long "XBlackPixel"))

(define x-white-pixel
  (c-lambda (Display* int) unsigned-long "XWhitePixel"))

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
  (c-lambda (Display* Window) int "XMapWindow"))

(define x-kill-client
  (c-lambda (Display* XID) int "XKillClient"))

(define x-flush
  (c-lambda (Display*) int "XFlush"))

(define x-sync
  (c-lambda (Display* bool) int "XSync"))

(define x-grab-key
  (c-lambda (Display* int unsigned-int Window bool int int) int "XGrabKey"))

(define x-ungrab-key
  (c-lambda (Display* int unsigned-int Window) int "XUngrabKey"))

(define x-grab-keyboard
  (c-lambda (Display* Window bool int int Time) int "XGrabKeyboard"))

(define x-ungrab-keyboard
  (c-lambda (Display* Time) int "XUngrabKeyboard"))

(define x-keysym-to-keycode
  (c-lambda (Display* KeySym) KeyCode "XKeysymToKeycode"))

(define x-keycode-to-keysym
  (c-lambda (Display* KeyCode int) KeySym "XKeycodeToKeysym"))

(define x-keysym-to-string
  (c-lambda (KeySym) char-string "XKeysymToString"))

(define x-string-to-keysym
  (c-lambda (char-string) KeySym "XStringToKeysym"))

(define x-ungrab-button
  (c-lambda (Display* int unsigned-int Window) int "XUngrabButton"))

(define x-grab-button
  (c-lambda (Display*
             unsigned-int
             unsigned-int
             Window
             bool
             unsigned-int
             int
             int
             Window
             Cursor)
            int
            "XGrabButton"))

(define x-create-gc
  (c-lambda (Display* Drawable unsigned-long XGCValues*)
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
  (c-lambda (Display* Drawable GC int int char* int) int "XDrawString"))

(define x-text-width
  (c-lambda (XFontStruct* char* int) int "XTextWidth"))

(define x-parse-color
  (c-lambda (Display* Colormap char* XColor*) Status "XParseColor"))

(define x-alloc-color
  (c-lambda (Display* Colormap XColor*) Status "XAllocColor"))

(define (make-x-color-box)
  ((c-lambda ()
             XColor*/release-rc
             "XLIB_SCM_ALLOC_OBJ(___result_voidstar, XColor);")))

(define (make-x-gc-values-box)
  ((c-lambda
     ()
     XGCValues*/release-rc
     "XLIB_SCM_ALLOC_OBJ(___result_voidstar, XGCValues);")))

(define x-set-input-focus
  (c-lambda (Display* Window int Time) int "XSetInputFocus"))

(define x-change-gc
  (c-lambda (Display* GC unsigned-long XGCValues*) int "XChangeGC"))

(define x-get-gc-values
  (c-lambda (Display* GC unsigned-long XGCValues*) int "XGetGCValues"))

(define x-query-font
  (c-lambda (Display* Font) XFontStruct*/XFree "XQueryFont"))

(define x-load-font
  (c-lambda (Display* char*) Font "XLoadFont"))

(define x-load-query-font
  (c-lambda (Display* char*) XFontStruct*/XFree "XLoadQueryFont"))

(define x-font-struct-fid
  (c-lambda (XFontStruct*) Font "___result = ___arg1->fid;"))

(define x-font-struct-ascent
  (c-lambda (XFontStruct*) int "___result = ___arg1->ascent;"))

(define x-font-struct-descent
  (c-lambda (XFontStruct*) int "___result = ___arg1->descent;"))

(define x-refresh-keyboard-mapping
  (c-lambda (XMappingEvent*)
            int
            "___result = XRefreshKeyboardMapping(&___arg1->xmapping);"))

(define x-pending
  (c-lambda (Display*) int "XPending"))

(define x-check-mask-event
  (c-lambda (Display* long)
            XEvent*/release-rc
            "
            XEvent ev, *pev = 0;
            if (XCheckMaskEvent (___arg1, ___arg2, &ev)) {
              XLIB_SCM_ALLOC_OBJ(pev, XEvent);
              *pev = ev;
            }
            ___result_voidstar = pev;
            "))

(define x-next-event
  (c-lambda (Display*)
            XEvent*/release-rc
            "
            XEvent ev, *pev;
            XNextEvent(___arg1, &ev);
            XLIB_SCM_ALLOC_OBJ(pev, XEvent);
            *pev = ev;
            ___result_voidstar = pev;
            "))

(c-define (query-tree-callback fn arg)
          (scheme-object Window)
          int
          "query_tree_callback"
          ""
          (fn arg)
          0)

(define x-map-query-tree
  (c-lambda (Display* Window scheme-object) int
            "
            Window root, parent, *wins = 0;
            unsigned int num, i;

            ___result = 0;
            if (XQueryTree(___arg1, ___arg2, &root, &parent, &wins, &num)) {
              fprintf(stderr, \"query-tree num: %d\\n\", num);
              for (i = 0; i < num; ++i)
                query_tree_callback(___arg3, wins[i]);
              XFree(wins);
              ___result = 1;
            }
            "))

(define (x-query-tree display window)
  ((c-lambda (Display* Window) scheme-object
#<<end-of-lambda
  Window root, parent, *wins = 0;
  unsigned int num, i;
  ___SCMOBJ ret;

  ___result = ___FIX(___UNKNOWN_ERR);
  if (XQueryTree(___arg1, ___arg2, &root, &parent, &wins, &num)) {
    ret = ___EXT(___alloc_scmobj)(___PSTATE, ___sU32VECTOR, num << 2);
    if (!___FIXNUMP(ret)) {
      for (i = 0; i < num; ++i)
        ___U32VECTORSET(ret, ___FIX(i), ___FIX((___CAST(___U32, wins[i]))));
      ___EXT(___release_scmobj)(ret);
      ___result = ret;
    }
  }
  if (wins)
    XFree(wins);
end-of-lambda
    )
    display
    window))

(define (x-get-wm-protocols display window)
  (let ((ret ((c-lambda (Display* Window) scheme-object
#<<end-of-lambda
  Atom *atoms = 0;
  int num, i;
  ___SCMOBJ ret;

  ___result = 0;
  if (XGetWMProtocols(___arg1, ___arg2, &atoms, &num)) {
    ret = ___EXT(___alloc_scmobj)(___PSTATE, ___sU32VECTOR, num << 2);
    if (!___FIXNUMP(ret)) {
      for (i = 0; i < num; ++i)
        ___U32VECTORSET(ret, ___FIX(i), ___FIX((___CAST(___U32, atoms[i]))));
    }
  } else
    ret = ___EXT(___alloc_scmobj)(___PSTATE, ___sU32VECTOR, 0);
  if (atoms)
    XFree(atoms);
  ___EXT(___release_scmobj)(ret);
  ___result = ret;
end-of-lambda
    )
    display
    window)))
    (if (u32vector? ret)
        (u32vector->list ret)
        #f)))

(define x-window-parent
  (c-lambda (Display* Window)
            Window
            "
            Window root, parent, *wins = 0;
            unsigned int num;

            ___result = None;
            if (XQueryTree(___arg1, ___arg2, &root, &parent, &wins, &num)) {
              if (wins)
                XFree(wins);
              ___result = parent;
            }
            "))

(define x-window-root
  (c-lambda (Display* Window)
            Window
            "
            Window root, parent, *wins = 0;
            unsigned int num;

            ___result = None;
            if (XQueryTree(___arg1, ___arg2, &root, &parent, &wins, &num)) {
              if (wins)
                XFree(wins);
              ___result = root;
            }
            "))

(define x-allow-events
  (c-lambda (Display* int Time) int "XAllowEvents"))

(define x-select-input
  (c-lambda (Display* Window long) int "XSelectInput"))

(define (make-x-event-box)
  ((c-lambda ()
             XEvent*/release-rc
             "XLIB_SCM_ALLOC_OBJ(___result_voidstar, XEvent);")))

(define x-send-event
  (c-lambda (Display* Window bool long XEvent*) Status "XSendEvent"))

(define x-lookup-string
  (c-lambda (XEvent*)
            KeySym
#<<end-of-c-lambda
char buf[10];
KeySym ks;
XComposeStatus cs;
int n = XLookupString (___CAST(XKeyEvent*,___arg1),
                       buf,
                       sizeof(buf),
                       &ks,
                       &cs);
___result = ks;
end-of-c-lambda
))

(define-x-pstruct-getter
  x-get-window-attributes
  (Display* Window)
  "XWindowAttributes"
  "XGetWindowAttributes(___arg1, ___arg2, &data);")

(define-x-pstruct-getter
  x-get-wm-normal-hints
  (Display* Window)
  "XSizeHints"
  "long msize;
   if(!XGetWMNormalHints(___arg1, ___arg2, &data, &msize))
      data.flags = PSize;")

(define (x-change-property-atoms dpy win atom lst)
  ((c-lambda (Display* Window Atom scheme-object) int
#<<end-of-lambda
  Atom *data = 0;
  long n, i;
  ___U32 *v;

  n = ___CAST(long, ___INT(___U32VECTORLENGTH(___arg4)));

  data = (Atom *)malloc(n * sizeof(Atom));
  if (n > 0 && data == 0)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  v = ___CAST(___U32*, ___BODY_AS(___arg4, ___tSUBTYPED));
  for (i = 0; i < n; ++i) {
    data[i] = v[i];
  }
  ___result = XChangeProperty(___arg1,
                              ___arg2,
                              ___arg3,
                              XA_ATOM,
                              32,
                              PropModeReplace,
                              (unsigned char *)data,
                              n);
  if (data)
    free(data);
#if 0
  fprintf(stderr, "(XChangeProperty) ret = %d\n", ___result);
#endif
end-of-lambda
    )
    dpy win atom (list->u32vector lst)))

(define set-x-window-state!
  (c-lambda (Display* Window Atom long)
            int
            "long data[] = {___arg4, None};
             ___result = XChangeProperty(___arg1,
                                         ___arg2,
                                         ___arg3,
                                         ___arg3,
                                         32,
                                         PropModeReplace,
                                         (unsigned char *)data,
                                         2);"))

(define x-set-window-border-width
  (c-lambda (Display* Window unsigned-int) int "XSetWindowBorderWidth"))

(define x-set-window-border
  (c-lambda (Display* Window unsigned-long) int "XSetWindowBorder"))

(define x-reparent-window
  (c-lambda (Display* Window Window int int) int "XReparentWindow"))

(define x-get-transient-for-hint
  (c-lambda (Display* Window)
            Window
            "Window win = None;
             if (XGetTransientForHint(___arg1, ___arg2, &win))
               ___result = win;
             else
               ___result = None;
            "))

(define x-get-text-property-list
  (lambda (display window atom)
    (vector->list ((c-lambda (Display* Window Atom) scheme-object
#<<end-of-lambda
  XTextProperty name;
  ___SCMOBJ ret, item;
  int num, i;
  char **list = 0;

  XGetTextProperty(___arg1, ___arg2, &name, ___arg3);
#if 0
  fprintf(stderr, "XGetTextProperty returned %ld entries\n", name.nitems);
#endif
  if (name.nitems > 0) {
    if (XmbTextPropertyToTextList(___arg1, &name, &list, &num) == Success) {
      ret = ___EXT(___alloc_scmobj)(___PSTATE, ___sVECTOR, num << ___LWS);
      for (i = 0; i < num; ++i) {
        ___err = ___EXT(___UTF_8STRING_to_SCMOBJ)(___PSTATE, list[i], &item,
                                                  0);
        if (___err != ___FIX(___NO_ERR))
          break;
#if 0
        fprintf(stderr, "(x-get-text-property-list) item[%d] = `%s'\n",
                i, list[i]);
#endif
        ___VECTORSET(ret, ___FIX(i), item);
        ___EXT(___release_scmobj)(item);
      }
    } else
      ret = ___EXT(___alloc_scmobj)(___sVECTOR, 0, 0);
    if (list)
      XFreeStringList(list);
    XFree(name.value);
  } else {
#if 0
    fprintf(stderr, "(x-get-text-property-list) is empty\n");
#endif
    ret = ___EXT(___alloc_scmobj)(___sVECTOR, 0, 0);
  }
  ___EXT(___release_scmobj)(ret);
  ___result = ret;
end-of-lambda
               )
             display
             window
             atom))))

(define x-get-window-property
  (c-lambda (Display* Window Atom) Atom
            "int di, ret;
             unsigned long dl;
             unsigned char *p;
             Atom da, atom = None;
             ret = XGetWindowProperty(___arg1, ___arg2, ___arg3, 0L,
                                      sizeof(atom), False, XA_ATOM, &da, &di,
                                      &dl, &dl, &p);
             if (ret == Success && p) {
               atom = *(Atom *)p;
               XFree(p);
             }
             ___result = atom;"))

(define x-get-class-hint
  (c-lambda (Display* Window) scheme-object
#<<end-of-lambda
  XClassHint hint;
  ___SCMOBJ ret;

  ret = ___NUL;
  if (XGetClassHint(___arg1, ___arg2, &hint)) {
    ___SCMOBJ name, class;
    ___err = ___EXT(___UTF_8STRING_to_SCMOBJ)(___PSTATE, hint.res_name, &name,
                                              0);
    if (___err != ___FIX(___NO_ERR)) {
      XFree(hint.res_name);
      XFree(hint.res_class);
      return ___err;
    }
    ___err = ___EXT(___UTF_8STRING_to_SCMOBJ)(___PSTATE, hint.res_class,
                                              &class, 0);
    if (___err != ___FIX(___NO_ERR)) {
      ___EXT(___release_scmobj)(name);
      XFree(hint.res_name);
      XFree(hint.res_class);
      return ___err;
    }
    ret = ___EXT(___make_pair)(___PSTATE, name, class);
    ___EXT(___release_scmobj)(name);
    ___EXT(___release_scmobj)(class);
    ___EXT(___release_scmobj)(ret);
    XFree(hint.res_name);
    XFree(hint.res_class);
  }
  ___result = ret;
end-of-lambda
))

(define x-move-resize-window
  (c-lambda (Display* Window int int unsigned-int unsigned-int)
            int
            "XMoveResizeWindow"))

(define x-move-window
  (c-lambda (Display* Window int int) int "XMoveWindow"))

(define x-resize-window
  (c-lambda (Display* Window unsigned-int unsigned-int)
            int
            "XResizeWindow"))

(define x-raise-window
  (c-lambda (Display* Window) int "XRaiseWindow"))

(define-x-setter
  x-configure-window
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
   ___result = XConfigureWindow(___arg1, ___arg2, ___arg3, &wc);")

(define-x-setter
  x-change-window-attributes
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
   (override-redirect Bool)
   (save-under Bool)
   (event-mask long)
   (do-not-propagate-mask long)
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
   wa.override_redirect = ___arg13;
   wa.save_under = ___arg14;
   wa.event_mask = ___arg15;
   wa.do_not_propagate_mask = ___arg16;
   wa.colormap = ___arg17;
   wa.cursor = ___arg18;
   ___result = XChangeWindowAttributes(___arg1, ___arg2, ___arg3, &wa);")

(define (x-call-with-x11-events x11-display fn)
  (let* ((x11-display-fd (x-connection-number x11-display))
         (x11-display-port (##open-predefined 1
                                              '(X11-display)
                                              x11-display-fd)))
    (let loop ()
      (##device-port-wait-for-input! x11-display-port)
      (if (fn)
          (loop)
          #f))))
