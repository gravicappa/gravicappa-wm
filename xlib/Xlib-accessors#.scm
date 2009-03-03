(define x-window-attributes-x
  (c-lambda (XWindowAttributes*)
            int
            "___result = ___arg1->x;"))

(define x-window-attributes-y
  (c-lambda (XWindowAttributes*)
            int
            "___result = ___arg1->y;"))

(define x-window-attributes-width
  (c-lambda (XWindowAttributes*)
            int
            "___result = ___arg1->width;"))

(define x-window-attributes-height
  (c-lambda (XWindowAttributes*)
            int
            "___result = ___arg1->height;"))

(define x-window-attributes-border-width
  (c-lambda (XWindowAttributes*)
            int
            "___result = ___arg1->border_width;"))

(define x-window-attributes-depth
  (c-lambda (XWindowAttributes*)
            int
            "___result = ___arg1->depth;"))

(define x-window-attributes-visual
  (c-lambda (XWindowAttributes*)
            Visual*
            "___result_voidstar = ___arg1->visual;"))

(define x-window-attributes-root
  (c-lambda (XWindowAttributes*)
            Window
            "___result = ___arg1->root;"))

(define x-window-attributes-class
  (c-lambda (XWindowAttributes*)
            int
            "___result = ___arg1->class;"))

(define x-window-attributes-bit-gravity
  (c-lambda (XWindowAttributes*)
            int
            "___result = ___arg1->bit_gravity;"))

(define x-window-attributes-win-gravity
  (c-lambda (XWindowAttributes*)
            int
            "___result = ___arg1->win_gravity;"))

(define x-window-attributes-backing-store
  (c-lambda (XWindowAttributes*)
            int
            "___result = ___arg1->backing_store;"))

(define x-window-attributes-backing-planes
  (c-lambda (XWindowAttributes*)
            unsigned-long
            "___result = ___arg1->backing_planes;"))

(define x-window-attributes-backing-pixel
  (c-lambda (XWindowAttributes*)
            unsigned-long
            "___result = ___arg1->backing_pixel;"))

(define x-window-attributes-save-under?
  (c-lambda (XWindowAttributes*)
            Bool
            "___result = ___arg1->save_under;"))

(define x-window-attributes-colormap
  (c-lambda (XWindowAttributes*)
            Colormap
            "___result = ___arg1->colormap;"))

(define x-window-attributes-map-installed?
  (c-lambda (XWindowAttributes*)
            Bool
            "___result = ___arg1->map_installed;"))

(define x-window-attributes-map-state
  (c-lambda (XWindowAttributes*)
            int
            "___result = ___arg1->map_state;"))

(define x-window-attributes-all-event-masks
  (c-lambda (XWindowAttributes*)
            long
            "___result = ___arg1->all_event_masks;"))

(define x-window-attributes-your-event-mask
  (c-lambda (XWindowAttributes*)
            long
            "___result = ___arg1->your_event_mask;"))

(define x-window-attributes-do-not-propagate-mask
  (c-lambda (XWindowAttributes*)
            long
            "___result = ___arg1->do_not_propagate_mask;"))

(define x-window-attributes-override-redirect?
  (c-lambda (XWindowAttributes*)
            Bool
            "___result = ___arg1->override_redirect;"))

(define x-window-attributes-screen
  (c-lambda (XWindowAttributes*)
            Screen*
            "___result_voidstar = ___arg1->screen;"))

