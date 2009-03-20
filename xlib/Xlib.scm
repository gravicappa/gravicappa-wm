;;;============================================================================
;;; File: "Xlib.scm", Time-stamp: <2009-01-13 14:06:51 feeley>
;;; Copyright (c) 2006-2009 by Marc Feeley, All Rights Reserved.
;;;
;;; A simple interface to the X Window System Xlib library.
;;; Note: This interface to Xlib is still in development.  There are
;;;       still memory leaks in the interface.
;;;============================================================================

(namespace ("Xlib#"))

(##include "~~lib/gambit#.scm")
(include "Xlib#.scm")

(declare
  (standard-bindings)
  (extended-bindings)
  (block)
  (not safe))

(define-macro (%eval-at-macroexpand expr)
  (eval expr)
  `(begin))

(%eval-at-macroexpand
  (define (%string-replace new old str)
    (list->string (map (lambda (c)
                         (if (char=? c old)
                             new
                             c))
                       (string->list str)))))

(define (%provided-mask v shift)
  (if (eq? v '())
      0
      (arithmetic-shift 1 shift)))

(define (%provided-value v default)
  (if (eq? v '())
      default
      v))

(%eval-at-macroexpand
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

(%eval-at-macroexpand
  (define (%get-default-value arg)
    (if (null? (cddr arg))
        (case (cadr arg)
          ((int unsigned-long unsigned-int Bool long) 0)
          ((Window Pixmap Cursor Colormap) '+none+)
          (else (error (string-append "Cannot determine default type for "
                                      (object->string (cadr arg))))))
        (caddr arg))))

(define-macro (%define/x-object name type)
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

(define-macro (%define/x-const name type c-name)
  `(define ,name
     ((c-lambda () ,type ,(string-append "___result = " c-name ";")))))

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

(define-macro (%define/x-pstruct-getter name args type code)
  (let ((ret-type (string->symbol (string-append type "*/release-rc"))))
    `(define ,name
       (c-lambda ,args
                 ,ret-type
                 ,(string-append
                   type " data, *pdata;\n"
                   code "\n"
                   "pdata = ___CAST(" type "*, (___alloc_rc)(sizeof(data)));
                   *pdata = data;
                   ___result_voidstar = pdata;
                   ")))))

;;;============================================================================

(c-declare "
#include <stdlib.h>
#include <stdio.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xatom.h>
#include <X11/Xproto.h>
#include <X11/keysym.h>
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
(c-define-type KeyCode unsigned-char)

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

(c-define-type GC (pointer (struct "_XGC") (GC)))
(c-define-type GC/XFree (pointer (struct "_XGC") (GC) "XFree_GC"))

(%define/x-object "XGCValues" "release-rc")
(%define/x-object "XEvent" "release-rc")
(%define/x-object "XErrorEvent" "release-rc")
(%define/x-object "XColor" "release-rc")
(%define/x-object "Visual" "XFree")
(%define/x-object "Screen" "XFree")
(%define/x-object "XFontStruct" "XFree")
(%define/x-object "Display" "XFree")
(%define/x-object "XWindowAttributes" "release-rc")
(%define/x-object "XSizeHints" "release-rc")

(include "Xlib-constants#.scm")
(include "Xlib-events#.scm")
(include "Xlib-accessors#.scm")

(define x-client-message-event-data-l
  (c-lambda (XEvent* int)
            long
            "___result = ___arg1->xclient.data.l[___arg2];"))

(define x-client-message-event-data-l-set!
  (c-lambda (XEvent* int long)
            void
            "___arg1->xclient.data.l[___arg2] = ___arg3;"))

(define (default-error-handler display ev)
  (let ((request-code (char->integer (x-error-event-request-code ev)))
        (error-code (char->integer (x-error-event-error-code ev))))
    (error (string-append "Xlib: error request-code:"
                          (number->string request-code)
                          " error-code: "
                          (number->string error-code)))))

(define error-handler default-error-handler)

(c-define (scheme-x-error-handler display ev)
          (Display* XEvent*)
          int
          "scheme_x_error_handler"
          ""
          (error-handler display ev)
          0)

(define x-set-error-handler
  (c-lambda ((function (Display* XEvent*) int))
            (pointer "void")
            "XSetErrorHandler"))

(define (set-x-error-handler! fn)
  (set! error-handler fn)
  (x-set-error-handler scheme-x-error-handler)
  (void))

(define x-size-hints-min-aspect-x
  (c-lambda (XSizeHints*) int "___result = ___arg1->min_aspect.x;"))

(define x-size-hints-min-aspect-y
  (c-lambda (XSizeHints*) int "___result = ___arg1->min_aspect.y;"))

(define x-size-hints-max-aspect-x
  (c-lambda (XSizeHints*) int "___result = ___arg1->max_aspect.x;"))

(define x-size-hints-max-aspect-y
  (c-lambda (XSizeHints*) int "___result = ___arg1->max_aspect.y;"))

(define x-open-display
  (c-lambda (char*)        ;; display_name
            Display*/XFree
            "XOpenDisplay"))

(define x-close-display
  (c-lambda (Display*)     ;; display
            int
            "XCloseDisplay"))

(define x-grab-server
  (c-lambda (Display*)
            int
            "XGrabServer"))

(define x-ungrab-server
  (c-lambda (Display*)
            int
            "XUngrabServer"))

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
            Screen*
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

(define x-intern-atom
  (c-lambda (Display* char-string Bool)
            Atom
            "XInternAtom"))

(define x-get-atom-name
  (c-lambda (Display* Atom)
            char-string
            "XGetAtomName"))

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

(define x-kill-client
  (c-lambda (Display*
             XID)
            int
            "XKillClient"))

(define x-flush
  (c-lambda (Display*)      ;; display
            int
            "XFlush"))

(define x-sync
  (c-lambda (Display*
             bool)
            int
            "XSync"))

(define x-grab-key
  (c-lambda (Display* int unsigned-int Window bool int int)
            int
            "XGrabKey"))

(define x-ungrab-key
  (c-lambda (Display* int unsigned-int Window)
            int
            "XUngrabKey"))

(define x-grab-keyboard
  (c-lambda (Display* Window bool int int Time)
            int
            "XGrabKeyboard"))

(define x-ungrab-keyboard
  (c-lambda (Display* Time)
            int
            "XUngrabKeyboard"))

(define x-keysym-to-keycode
  (c-lambda (Display* KeySym)
            KeyCode
            "XKeysymToKeycode"))

(define x-keycode-to-keysym
  (c-lambda (Display* KeyCode int)
            KeySym
            "XKeycodeToKeysym"))

(define x-keysym-to-string
  (c-lambda (KeySym)
            char-string
            "XKeysymToString"))

(define x-string-to-keysym
  (c-lambda (char-string)
            KeySym
            "XStringToKeysym"))

(define x-ungrab-button
  (c-lambda (Display* int unsigned-int Window)
            int
            "XUngrabButton"))

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
             "___result_voidstar = ___EXT(___alloc_rc)(sizeof(XColor));")))

(define (make-x-gc-values-box)
  ((c-lambda
     ()
     XGCValues*/release-rc
     "___result_voidstar = ___EXT(___alloc_rc)(sizeof(XGCValues));")))

(define x-set-input-focus
  (c-lambda (Display* Window int Time)
            int
            "XSetInputFocus"))

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

(define x-refresh-keyboard-mapping
  (c-lambda (XEvent*)
            int
            "XRefreshKeyboardMapping"))

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
            if (XCheckMaskEvent (___arg1, ___arg2, &ev)) {
              pev = ___CAST(XEvent*, ___EXT(___alloc_rc)(sizeof (ev)));
              *pev = ev;
            } else
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
            pev = ___CAST(XEvent*, ___EXT(___alloc_rc)(sizeof(ev)));
            *pev = ev;
            ___result_voidstar = pev;
            "
            ))

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
            unsigned int num;

            ___result = 0;
            if (XQueryTree(___arg1, ___arg2, &root, &parent, &wins, &num)) {
              unsigned int i;

              for (i = 0; i < num; ++i) {
                query_tree_callback(___arg3, wins[i]);
              }
              ___result = 1;
            }
            "))

(define (x-query-tree display window)
  (reverse 
    ((c-lambda (Display* Window) scheme-object
#<<end-of-lambda
  Window root, parent, *wins = 0;
  unsigned int num;
  ___SCMOBJ ret;

  ___result = ___NUL;
  ret = ___NUL;
  if (XQueryTree(___arg1, ___arg2, &root, &parent, &wins, &num)) {
    unsigned int i;

    for (i = 0; i < num; ++i) {
      ___SCMOBJ item, tmp;
      ___err = ___EXT(___U32_to_SCMOBJ)(wins[i], &item, ___STILL);
      if (___err != ___FIX(___NO_ERR)) {
        ___EXT(___release_scmobj)(ret);
        if (wins)
          XFree(wins);
        return ___err;
      }
      tmp = ___EXT(___make_pair)(item, ret, ___STILL);
      ___EXT(___release_scmobj)(ret);
      ___EXT(___release_scmobj)(item);
      ret = tmp;
    }
  }
  if (wins)
    XFree(wins);
  ___EXT(___release_scmobj)(ret);
  ___result = ret;
end-of-lambda
    ) 
    display
    window)))

(define (x-get-wm-protocols display window)
  (reverse 
    ((c-lambda (Display* Window) scheme-object
#<<end-of-lambda
  Atom *atoms = 0;
  int num;
  ___SCMOBJ ret;

  ___result = ___NUL;
  ret = ___NUL;
  if (XGetWMProtocols(___arg1, ___arg2, &atoms, &num)) {
    int i;

    for (i = 0; i < num; ++i) {
      ___SCMOBJ item, tmp;
      ___err = ___EXT(___U32_to_SCMOBJ)(atoms[i], &item, ___STILL);
      if (___err != ___FIX(___NO_ERR)) {
        ___EXT(___release_scmobj)(ret);
        if (atoms)
          XFree(atoms);
        return ___err;
      }
      tmp = ___EXT(___make_pair)(item, ret, ___STILL);
      ___EXT(___release_scmobj)(ret);
      ___EXT(___release_scmobj)(item);
      ret = tmp;
    }
  }
  if (atoms)
    XFree(atoms);
  ___EXT(___release_scmobj)(ret);
  ___result = ret;
end-of-lambda
    ) 
    display
    window)))

(define x-window-parent
  (c-lambda (Display* Window)
            Window
            "
            Window root, parent, *wins = 0;
            unsigned int num;

            ___result = None;
            if (XQueryTree(___arg1, ___arg2, &root, &parent, &wins, &num)) {
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
              ___result = root;
            }
            "))

(define x-allow-events
  (c-lambda (Display* int Time)
            int
            "XAllowEvents"))

(define x-select-input
  (c-lambda (Display*       ;; display
             Window         ;; w
             long)          ;; event_mask
            int
            "XSelectInput"))

(define (make-x-event-box)
  ((c-lambda ()
             XEvent*/release-rc
             "___result_voidstar = ___EXT(___alloc_rc)(sizeof (XEvent));")))

(define x-send-event
  (c-lambda (Display* Window bool long XEvent*)
            Status
            "XSendEvent"))

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

(%define/x-pstruct-getter x-get-window-attributes
                          (Display* Window)
                          "XWindowAttributes"
                          "XGetWindowAttributes(___arg1, ___arg2, &data);")

(%define/x-pstruct-getter x-get-wm-normal-hints
                          (Display* Window)
                          "XSizeHints"
                          "long msize;
                          if(!XGetWMNormalHints(___arg1,
                                                ___arg2,
                                                &data,
                                                &msize))
                            data.flags = PSize;")

(define x-change-property-atoms
  (c-lambda (Display* Window Atom scheme-object)
            int
#<<end-of-lambda
  Atom *data = 0, *ptr;
  long length = 0;
  ___SCMOBJ lst;

  lst = ___arg4;
  for (length = 0; ___PAIRP(lst); lst = ___CDR(lst), ++length);

#if 0
  fprintf(stderr, "(XChangeProperty) %d items\n", length);
#endif
  data = (Atom *)malloc(length * sizeof(Atom));
  if (data == 0)
    return ___FIX(___HEAP_OVERFLOW_ERR);

  for (lst = ___arg4, ptr = data;
       ___PAIRP(lst);
       lst = ___CDR(lst), ++ptr) {
    ___SCMOBJ item = ___CAR(lst);
    ___err = ___EXT(___SCMOBJ_to_U32)(item, (___U32 *)ptr, ___STILL);
    if (___err != ___FIX(___NO_ERR)) {
      free(data);
      return ___err;
    }
#if 0
  fprintf(stderr, "(XChangeProperty) item = %ld\n", *ptr);
#endif
  }
  ___result = XChangeProperty(___arg1,
                              ___arg2,
                              ___arg3,
                              XA_ATOM,
                              32,
                              PropModeReplace,
                              (unsigned char *)data,
                              length);
  free(data);
end-of-lambda
))

(define x-window-state-set!
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
  (c-lambda (Display* Window unsigned-int)
            int
            "XSetWindowBorderWidth"))

(define x-set-window-border
  (c-lambda (Display* Window unsigned-long)
            int
            "XSetWindowBorder"))

(define x-reparent-window
  (c-lambda (Display* Window Window int int)
            int
            "XReparentWindow"))

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
    (reverse ((c-lambda (Display* Window Atom) scheme-object
#<<end-of-lambda
  XTextProperty name;
  ___SCMOBJ ret;
  int n;
  char **list = 0;

  ret = ___NUL;
  XGetTextProperty(___arg1, ___arg2, &name, ___arg3);
  /*
  fprintf(stderr, "XGetTextProperty returned %ld entries\n", name.nitems);
  */
  if (name.nitems > 0) {
    if (XmbTextPropertyToTextList(___arg1, &name, &list, &n)) {
      int i;
      /*
      fprintf(stderr, "XmbTextPropertyToTextList returned %d entries\n", n);
      */
      for (i = 0; i < n; ++i) {
        ___SCMOBJ item, tmp;
        ___err = ___EXT(___UTF_8STRING_to_SCMOBJ)(list[i],
                                                  &item,
                                                  ___STILL);
        if (___err != ___FIX(___NO_ERR)) {
          ___EXT(___release_scmobj)(ret);
          XFree(name.value);
          return ___err;
        }
#if 1
        fprintf(stderr, "item[%d] = `%s'\n", i, list[i]);
#endif
        tmp = ___EXT(___make_pair)(item, ret, ___STILL);
        ___EXT(___release_scmobj)(ret);
        ___EXT(___release_scmobj)(item);
        ret = tmp;
      }
    }
    XFree(name.value);
  }
  ___EXT(___release_scmobj)(ret);

  ___result = ret;
end-of-lambda
               )
             display
             window
             atom))))

(define x-get-class-hint
  (c-lambda (Display* Window)
            scheme-object
#<<end-of-lambda
  XClassHint hint;
  ___SCMOBJ ret;

  ret = ___NUL;
  if (XGetClassHint(___arg1, ___arg2, &hint)) {
    ___SCMOBJ name, class;
    ___err = ___EXT(___UTF_8STRING_to_SCMOBJ)(hint.res_name,
                                              &name,
                                              ___STILL);
    if (___err != ___FIX(___NO_ERR)) {
      XFree(hint.res_name);
      XFree(hint.res_class);
      return ___err;
    }
    ___err = ___EXT(___UTF_8STRING_to_SCMOBJ)(hint.res_class,
                                              &class,
                                              ___STILL);
    if (___err != ___FIX(___NO_ERR)) {
      ___EXT(___release_scmobj)(name);
      XFree(hint.res_name);
      XFree(hint.res_class);
      return ___err;
    }
    ret = ___EXT(___make_pair)(name, class, ___STILL);
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
  (c-lambda (Display* Window int int)
            int
            "XMoveWindow"))

(define x-resize-window
  (c-lambda (Display* Window unsigned-int unsigned-int)
            int
            "XResizeWindow"))

(define x-raise-window
  (c-lambda (Display* Window)
            int
            "XRaiseWindow"))

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
                  ___result = XChangeWindowAttributes(___arg1,
                                                      ___arg2,
                                                      ___arg3,
                                                      &wa);
                  ")

(define (call-with-x11-events x11-display fn)
  (let* ((x11-display-fd (x-connection-number x11-display))
         (x11-display-port (##open-predefined 1
                                              '(X11-display)
                                              x11-display-fd)))
    (let loop ()
      (##device-port-wait-for-input! x11-display-port)
      (if (fn)
          (loop)
          #f))))
;;;============================================================================
;;;============================================================================
