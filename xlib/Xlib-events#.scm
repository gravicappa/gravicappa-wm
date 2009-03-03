;; XAnyEvent slots accessors

(define x-any-event-type
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xany.type;"))

(define x-any-event-serial
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xany.serial;"))

(define x-any-event-send-event?
  (c-lambda (XEvent*) 
            Bool 
            "___result = ___arg1->xany.send_event;"))

(define x-any-event-window
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xany.window;"))

;; XKeyEvent slots accessors

(define x-key-event-root
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xkey.root;"))

(define x-key-event-time
  (c-lambda (XEvent*) 
            Time 
            "___result = ___arg1->xkey.time;"))

(define x-key-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xkey.x;"))

(define x-key-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xkey.y;"))

(define x-key-event-x-root
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xkey.x_root;"))

(define x-key-event-y-root
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xkey.y_root;"))

(define x-key-event-state
  (c-lambda (XEvent*) 
            unsigned-int 
            "___result = ___arg1->xkey.state;"))

(define x-key-event-keycode
  (c-lambda (XEvent*) 
            unsigned-int 
            "___result = ___arg1->xkey.keycode;"))

(define x-key-event-same-screen?
  (c-lambda (XEvent*) 
            Bool 
            "___result = ___arg1->xkey.same_screen;"))

;; XButtonEvent slots accessors

(define x-button-event-root
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xbutton.root;"))

(define x-button-event-time
  (c-lambda (XEvent*) 
            Time 
            "___result = ___arg1->xbutton.time;"))

(define x-button-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xbutton.x;"))

(define x-button-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xbutton.y;"))

(define x-button-event-x-root
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xbutton.x_root;"))

(define x-button-event-y-root
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xbutton.y_root;"))

(define x-button-event-state
  (c-lambda (XEvent*) 
            unsigned-int 
            "___result = ___arg1->xbutton.state;"))

(define x-button-event-button
  (c-lambda (XEvent*) 
            unsigned-int 
            "___result = ___arg1->xbutton.button;"))

(define x-button-event-same-screen?
  (c-lambda (XEvent*) 
            Bool 
            "___result = ___arg1->xbutton.same_screen;"))

;; XMotionEvent slots accessors

(define x-motion-event-root
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xmotion.root;"))

(define x-motion-event-time
  (c-lambda (XEvent*) 
            Time 
            "___result = ___arg1->xmotion.time;"))

(define x-motion-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xmotion.x;"))

(define x-motion-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xmotion.y;"))

(define x-motion-event-x-root
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xmotion.x_root;"))

(define x-motion-event-y-root
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xmotion.y_root;"))

(define x-motion-event-state
  (c-lambda (XEvent*) 
            unsigned-int 
            "___result = ___arg1->xmotion.state;"))

(define x-motion-event-is-hint
  (c-lambda (XEvent*) 
            char 
            "___result = ___arg1->xmotion.is_hint;"))

(define x-motion-event-same-screen?
  (c-lambda (XEvent*) 
            Bool 
            "___result = ___arg1->xmotion.same_screen;"))

;; XCrossingEvent slots accessors

(define x-crossing-event-root
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xcrossing.root;"))

(define x-crossing-event-time
  (c-lambda (XEvent*) 
            Time 
            "___result = ___arg1->xcrossing.time;"))

(define x-crossing-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcrossing.x;"))

(define x-crossing-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcrossing.y;"))

(define x-crossing-event-x-root
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcrossing.x_root;"))

(define x-crossing-event-y-root
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcrossing.y_root;"))

(define x-crossing-event-mode
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcrossing.mode;"))

(define x-crossing-event-detail
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcrossing.detail;"))

(define x-crossing-event-same-screen?
  (c-lambda (XEvent*) 
            Bool 
            "___result = ___arg1->xcrossing.same_screen;"))

(define x-crossing-event-focus?
  (c-lambda (XEvent*) 
            Bool 
            "___result = ___arg1->xcrossing.focus;"))

(define x-crossing-event-state
  (c-lambda (XEvent*) 
            unsigned-int 
            "___result = ___arg1->xcrossing.state;"))

;; XFocusChangeEvent slots accessors

(define x-focus-change-event-mode
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xfocus.mode;"))

(define x-focus-change-event-detail
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xfocus.detail;"))

;; XExposeEvent slots accessors

(define x-expose-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xexpose.x;"))

(define x-expose-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xexpose.y;"))

(define x-expose-event-width
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xexpose.width;"))

(define x-expose-event-height
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xexpose.height;"))

(define x-expose-event-count
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xexpose.count;"))

;; XGraphicsExposeEvent slots accessors

(define x-graphics-expose-event-drawable
  (c-lambda (XEvent*) 
            Drawable 
            "___result = ___arg1->xgraphicsexpose.drawable;"))

(define x-graphics-expose-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgraphicsexpose.x;"))

(define x-graphics-expose-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgraphicsexpose.y;"))

(define x-graphics-expose-event-width
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgraphicsexpose.width;"))

(define x-graphics-expose-event-height
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgraphicsexpose.height;"))

(define x-graphics-expose-event-count
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgraphicsexpose.count;"))

(define x-graphics-expose-event-major-code
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgraphicsexpose.major_code;"))

(define x-graphics-expose-event-minor-code
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgraphicsexpose.minor_code;"))

;; XNoExposeEvent slots accessors

(define x-no-expose-event-drawable
  (c-lambda (XEvent*) 
            Drawable 
            "___result = ___arg1->xnoexpose.drawable;"))

(define x-no-expose-event-major-code
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xnoexpose.major_code;"))

(define x-no-expose-event-minor-code
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xnoexpose.minor_code;"))

;; XVisibilityEvent slots accessors

(define x-visibility-event-state
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xvisibility.state;"))

;; XCreateWindowEvent slots accessors

(define x-create-window-event-parent
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xcreatewindow.parent;"))

(define x-create-window-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcreatewindow.x;"))

(define x-create-window-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcreatewindow.y;"))

(define x-create-window-event-width
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcreatewindow.width;"))

(define x-create-window-event-height
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcreatewindow.height;"))

(define x-create-window-event-border-width
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcreatewindow.border_width;"))

(define x-create-window-event-override-redirect?
  (c-lambda (XEvent*) 
            Bool 
            "___result = ___arg1->xcreatewindow.override_redirect;"))

;; XDestroyWindowEvent slots accessors

(define x-destroy-window-event-event
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xdestroywindow.event;"))

;; XUnmapEvent slots accessors

(define x-unmap-event-event
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xunmap.event;"))

(define x-unmap-event-from-configure?
  (c-lambda (XEvent*) 
            Bool 
            "___result = ___arg1->xunmap.from_configure;"))

;; XMapEvent slots accessors

(define x-map-event-event
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xmap.event;"))

(define x-map-event-override-redirect?
  (c-lambda (XEvent*) 
            Bool 
            "___result = ___arg1->xmap.override_redirect;"))

;; XMapRequestEvent slots accessors

(define x-map-request-event-parent
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xmaprequest.parent;"))

;; XReparentEvent slots accessors

(define x-reparent-event-event
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xreparent.event;"))

(define x-reparent-event-parent
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xreparent.parent;"))

(define x-reparent-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xreparent.x;"))

(define x-reparent-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xreparent.y;"))

(define x-reparent-event-override-redirect?
  (c-lambda (XEvent*) 
            Bool 
            "___result = ___arg1->xreparent.override_redirect;"))

;; XConfigureEvent slots accessors

(define x-configure-event-event
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xconfigure.event;"))

(define x-configure-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigure.x;"))

(define x-configure-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigure.y;"))

(define x-configure-event-width
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigure.width;"))

(define x-configure-event-height
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigure.height;"))

(define x-configure-event-border-width
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigure.border_width;"))

(define x-configure-event-above
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xconfigure.above;"))

(define x-configure-event-override-redirect?
  (c-lambda (XEvent*) 
            Bool 
            "___result = ___arg1->xconfigure.override_redirect;"))

;; XGravityEvent slots accessors

(define x-gravity-event-event
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xgravity.event;"))

(define x-gravity-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgravity.x;"))

(define x-gravity-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xgravity.y;"))

;; XResizeRequestEvent slots accessors

(define x-resize-request-event-width
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xresizerequest.width;"))

(define x-resize-request-event-height
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xresizerequest.height;"))

;; XConfigureRequestEvent slots accessors

(define x-configure-request-event-parent
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xconfigurerequest.parent;"))

(define x-configure-request-event-x
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigurerequest.x;"))

(define x-configure-request-event-y
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigurerequest.y;"))

(define x-configure-request-event-width
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigurerequest.width;"))

(define x-configure-request-event-height
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigurerequest.height;"))

(define x-configure-request-event-border-width
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigurerequest.border_width;"))

(define x-configure-request-event-above
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xconfigurerequest.above;"))

(define x-configure-request-event-detail
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xconfigurerequest.detail;"))

(define x-configure-request-event-value-mask
  (c-lambda (XEvent*) 
            unsigned-long 
            "___result = ___arg1->xconfigurerequest.value_mask;"))

;; XCirculateEvent slots accessors

(define x-circulate-event-event
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xcirculate.event;"))

(define x-circulate-event-place
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcirculate.place;"))

;; XCirculateRequestEvent slots accessors

(define x-circulate-request-event-parent
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xcirculaterequest.parent;"))

(define x-circulate-request-event-place
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcirculaterequest.place;"))

;; XPropertyEvent slots accessors

(define x-property-event-atom
  (c-lambda (XEvent*) 
            Atom 
            "___result = ___arg1->xproperty.atom;"))

(define x-property-event-time
  (c-lambda (XEvent*) 
            Time 
            "___result = ___arg1->xproperty.time;"))

(define x-property-event-state
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xproperty.state;"))

;; XSelectionClearEvent slots accessors

(define x-selection-clear-event-selection
  (c-lambda (XEvent*) 
            Atom 
            "___result = ___arg1->xselectionclear.selection;"))

(define x-selection-clear-event-time
  (c-lambda (XEvent*) 
            Time 
            "___result = ___arg1->xselectionclear.time;"))

;; XSelectionRequestEvent slots accessors

(define x-selection-request-event-owner
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xselectionrequest.owner;"))

(define x-selection-request-event-requestor
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xselectionrequest.requestor;"))

(define x-selection-request-event-selection
  (c-lambda (XEvent*) 
            Atom 
            "___result = ___arg1->xselectionrequest.selection;"))

(define x-selection-request-event-target
  (c-lambda (XEvent*) 
            Atom 
            "___result = ___arg1->xselectionrequest.target;"))

(define x-selection-request-event-property
  (c-lambda (XEvent*) 
            Atom 
            "___result = ___arg1->xselectionrequest.property;"))

(define x-selection-request-event-time
  (c-lambda (XEvent*) 
            Time 
            "___result = ___arg1->xselectionrequest.time;"))

;; XSelectionEvent slots accessors

(define x-selection-event-requestor
  (c-lambda (XEvent*) 
            Window 
            "___result = ___arg1->xselection.requestor;"))

(define x-selection-event-selection
  (c-lambda (XEvent*) 
            Atom 
            "___result = ___arg1->xselection.selection;"))

(define x-selection-event-target
  (c-lambda (XEvent*) 
            Atom 
            "___result = ___arg1->xselection.target;"))

(define x-selection-event-property
  (c-lambda (XEvent*) 
            Atom 
            "___result = ___arg1->xselection.property;"))

(define x-selection-event-time
  (c-lambda (XEvent*) 
            Time 
            "___result = ___arg1->xselection.time;"))

;; XColormapEvent slots accessors

(define x-colormap-event-colormap
  (c-lambda (XEvent*) 
            Colormap 
            "___result = ___arg1->xcolormap.colormap;"))

(define x-colormap-event-c-new?
  (c-lambda (XEvent*) 
            Bool 
            "___result = ___arg1->xcolormap.new;"))

(define x-colormap-event-state
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xcolormap.state;"))

;; XClientMessageEvent slots accessors

(define x-client-message-event-format
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xclient.format;"))

;; XMappingEvent slots accessors

(define x-mapping-event-request
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xmapping.request;"))

(define x-mapping-event-first-keycode
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xmapping.first_keycode;"))

(define x-mapping-event-count
  (c-lambda (XEvent*) 
            int 
            "___result = ___arg1->xmapping.count;"))

;; XErrorEvent slots accessors

(define x-error-event-resourceid
  (c-lambda (XEvent*) 
            XID 
            "___result = ___arg1->xerror.resourceid;"))

(define x-error-event-error-code
  (c-lambda (XEvent*) 
            unsigned-char 
            "___result = ___arg1->xerror.error_code;"))

(define x-error-event-request-code
  (c-lambda (XEvent*) 
            unsigned-char 
            "___result = ___arg1->xerror.request_code;"))

(define x-error-event-minor-code
  (c-lambda (XEvent*) 
            unsigned-char 
            "___result = ___arg1->xerror.minor_code;"))

