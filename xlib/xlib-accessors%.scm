(define x-window-attributes-x
  (c-lambda (XWindowAttributes*)
            int
            "___result = ___arg1->x;"))

(define set-x-window-attributes-x!
  (c-lambda (XWindowAttributes* int)
            void
            "___arg1->x = ___arg2;"))

(define x-window-attributes-y
  (c-lambda (XWindowAttributes*)
            int
            "___result = ___arg1->y;"))

(define set-x-window-attributes-y!
  (c-lambda (XWindowAttributes* int)
            void
            "___arg1->y = ___arg2;"))

(define x-window-attributes-width
  (c-lambda (XWindowAttributes*)
            int
            "___result = ___arg1->width;"))

(define set-x-window-attributes-width!
  (c-lambda (XWindowAttributes* int)
            void
            "___arg1->width = ___arg2;"))

(define x-window-attributes-height
  (c-lambda (XWindowAttributes*)
            int
            "___result = ___arg1->height;"))

(define set-x-window-attributes-height!
  (c-lambda (XWindowAttributes* int)
            void
            "___arg1->height = ___arg2;"))

(define x-window-attributes-border-width
  (c-lambda (XWindowAttributes*)
            int
            "___result = ___arg1->border_width;"))

(define set-x-window-attributes-border-width!
  (c-lambda (XWindowAttributes* int)
            void
            "___arg1->border_width = ___arg2;"))

(define x-window-attributes-depth
  (c-lambda (XWindowAttributes*)
            int
            "___result = ___arg1->depth;"))

(define set-x-window-attributes-depth!
  (c-lambda (XWindowAttributes* int)
            void
            "___arg1->depth = ___arg2;"))

(define x-window-attributes-root
  (c-lambda (XWindowAttributes*)
            Window
            "___result = ___arg1->root;"))

(define set-x-window-attributes-root!
  (c-lambda (XWindowAttributes* Window)
            void
            "___arg1->root = ___arg2;"))

(define x-window-attributes-class
  (c-lambda (XWindowAttributes*)
            int
            "___result = ___arg1->class;"))

(define set-x-window-attributes-class!
  (c-lambda (XWindowAttributes* int)
            void
            "___arg1->class = ___arg2;"))

(define x-window-attributes-bit-gravity
  (c-lambda (XWindowAttributes*)
            int
            "___result = ___arg1->bit_gravity;"))

(define set-x-window-attributes-bit-gravity!
  (c-lambda (XWindowAttributes* int)
            void
            "___arg1->bit_gravity = ___arg2;"))

(define x-window-attributes-win-gravity
  (c-lambda (XWindowAttributes*)
            int
            "___result = ___arg1->win_gravity;"))

(define set-x-window-attributes-win-gravity!
  (c-lambda (XWindowAttributes* int)
            void
            "___arg1->win_gravity = ___arg2;"))

(define x-window-attributes-backing-store
  (c-lambda (XWindowAttributes*)
            int
            "___result = ___arg1->backing_store;"))

(define set-x-window-attributes-backing-store!
  (c-lambda (XWindowAttributes* int)
            void
            "___arg1->backing_store = ___arg2;"))

(define x-window-attributes-backing-planes
  (c-lambda (XWindowAttributes*)
            unsigned-long
            "___result = ___arg1->backing_planes;"))

(define set-x-window-attributes-backing-planes!
  (c-lambda (XWindowAttributes* unsigned-long)
            void
            "___arg1->backing_planes = ___arg2;"))

(define x-window-attributes-backing-pixel
  (c-lambda (XWindowAttributes*)
            unsigned-long
            "___result = ___arg1->backing_pixel;"))

(define set-x-window-attributes-backing-pixel!
  (c-lambda (XWindowAttributes* unsigned-long)
            void
            "___arg1->backing_pixel = ___arg2;"))

(define x-window-attributes-save-under?
  (c-lambda (XWindowAttributes*)
            bool
            "___result = ___arg1->save_under;"))

(define set-x-window-attributes-save-under!
  (c-lambda (XWindowAttributes* bool)
            void
            "___arg1->save_under = ___arg2;"))

(define x-window-attributes-colormap
  (c-lambda (XWindowAttributes*)
            Colormap
            "___result = ___arg1->colormap;"))

(define set-x-window-attributes-colormap!
  (c-lambda (XWindowAttributes* Colormap)
            void
            "___arg1->colormap = ___arg2;"))

(define x-window-attributes-map-installed?
  (c-lambda (XWindowAttributes*)
            bool
            "___result = ___arg1->map_installed;"))

(define set-x-window-attributes-map-installed!
  (c-lambda (XWindowAttributes* bool)
            void
            "___arg1->map_installed = ___arg2;"))

(define x-window-attributes-map-state
  (c-lambda (XWindowAttributes*)
            int
            "___result = ___arg1->map_state;"))

(define set-x-window-attributes-map-state!
  (c-lambda (XWindowAttributes* int)
            void
            "___arg1->map_state = ___arg2;"))

(define x-window-attributes-all-event-masks
  (c-lambda (XWindowAttributes*)
            long
            "___result = ___arg1->all_event_masks;"))

(define set-x-window-attributes-all-event-masks!
  (c-lambda (XWindowAttributes* long)
            void
            "___arg1->all_event_masks = ___arg2;"))

(define x-window-attributes-your-event-mask
  (c-lambda (XWindowAttributes*)
            long
            "___result = ___arg1->your_event_mask;"))

(define set-x-window-attributes-your-event-mask!
  (c-lambda (XWindowAttributes* long)
            void
            "___arg1->your_event_mask = ___arg2;"))

(define x-window-attributes-do-not-propagate-mask
  (c-lambda (XWindowAttributes*)
            long
            "___result = ___arg1->do_not_propagate_mask;"))

(define set-x-window-attributes-do-not-propagate-mask!
  (c-lambda (XWindowAttributes* long)
            void
            "___arg1->do_not_propagate_mask = ___arg2;"))

(define x-window-attributes-override-redirect?
  (c-lambda (XWindowAttributes*)
            bool
            "___result = ___arg1->override_redirect;"))

(define set-x-window-attributes-override-redirect!
  (c-lambda (XWindowAttributes* bool)
            void
            "___arg1->override_redirect = ___arg2;"))

(define x-size-hints-flags
  (c-lambda (XSizeHints*)
            long
            "___result = ___arg1->flags;"))

(define set-x-size-hints-flags!
  (c-lambda (XSizeHints* long)
            void
            "___arg1->flags = ___arg2;"))

(define x-size-hints-x
  (c-lambda (XSizeHints*)
            int
            "___result = ___arg1->x;"))

(define set-x-size-hints-x!
  (c-lambda (XSizeHints* int)
            void
            "___arg1->x = ___arg2;"))

(define x-size-hints-y
  (c-lambda (XSizeHints*)
            int
            "___result = ___arg1->y;"))

(define set-x-size-hints-y!
  (c-lambda (XSizeHints* int)
            void
            "___arg1->y = ___arg2;"))

(define x-size-hints-width
  (c-lambda (XSizeHints*)
            int
            "___result = ___arg1->width;"))

(define set-x-size-hints-width!
  (c-lambda (XSizeHints* int)
            void
            "___arg1->width = ___arg2;"))

(define x-size-hints-height
  (c-lambda (XSizeHints*)
            int
            "___result = ___arg1->height;"))

(define set-x-size-hints-height!
  (c-lambda (XSizeHints* int)
            void
            "___arg1->height = ___arg2;"))

(define x-size-hints-min-width
  (c-lambda (XSizeHints*)
            int
            "___result = ___arg1->min_width;"))

(define set-x-size-hints-min-width!
  (c-lambda (XSizeHints* int)
            void
            "___arg1->min_width = ___arg2;"))

(define x-size-hints-min-height
  (c-lambda (XSizeHints*)
            int
            "___result = ___arg1->min_height;"))

(define set-x-size-hints-min-height!
  (c-lambda (XSizeHints* int)
            void
            "___arg1->min_height = ___arg2;"))

(define x-size-hints-max-width
  (c-lambda (XSizeHints*)
            int
            "___result = ___arg1->max_width;"))

(define set-x-size-hints-max-width!
  (c-lambda (XSizeHints* int)
            void
            "___arg1->max_width = ___arg2;"))

(define x-size-hints-max-height
  (c-lambda (XSizeHints*)
            int
            "___result = ___arg1->max_height;"))

(define set-x-size-hints-max-height!
  (c-lambda (XSizeHints* int)
            void
            "___arg1->max_height = ___arg2;"))

(define x-size-hints-width-inc
  (c-lambda (XSizeHints*)
            int
            "___result = ___arg1->width_inc;"))

(define set-x-size-hints-width-inc!
  (c-lambda (XSizeHints* int)
            void
            "___arg1->width_inc = ___arg2;"))

(define x-size-hints-height-inc
  (c-lambda (XSizeHints*)
            int
            "___result = ___arg1->height_inc;"))

(define set-x-size-hints-height-inc!
  (c-lambda (XSizeHints* int)
            void
            "___arg1->height_inc = ___arg2;"))

(define x-size-hints-base-width
  (c-lambda (XSizeHints*)
            int
            "___result = ___arg1->base_width;"))

(define set-x-size-hints-base-width!
  (c-lambda (XSizeHints* int)
            void
            "___arg1->base_width = ___arg2;"))

(define x-size-hints-base-height
  (c-lambda (XSizeHints*)
            int
            "___result = ___arg1->base_height;"))

(define set-x-size-hints-base-height!
  (c-lambda (XSizeHints* int)
            void
            "___arg1->base_height = ___arg2;"))

(define x-size-hints-win-gravity
  (c-lambda (XSizeHints*)
            int
            "___result = ___arg1->win_gravity;"))

(define set-x-size-hints-win-gravity!
  (c-lambda (XSizeHints* int)
            void
            "___arg1->win_gravity = ___arg2;"))

(define x-color-pixel
  (c-lambda (XColor*)
            unsigned-long
            "___result = ___arg1->pixel;"))

(define set-x-color-pixel!
  (c-lambda (XColor* unsigned-long)
            void
            "___arg1->pixel = ___arg2;"))

(define x-color-red
  (c-lambda (XColor*)
            unsigned-short
            "___result = ___arg1->red;"))

(define set-x-color-red!
  (c-lambda (XColor* unsigned-short)
            void
            "___arg1->red = ___arg2;"))

(define x-color-green
  (c-lambda (XColor*)
            unsigned-short
            "___result = ___arg1->green;"))

(define set-x-color-green!
  (c-lambda (XColor* unsigned-short)
            void
            "___arg1->green = ___arg2;"))

(define x-color-blue
  (c-lambda (XColor*)
            unsigned-short
            "___result = ___arg1->blue;"))

(define set-x-color-blue!
  (c-lambda (XColor* unsigned-short)
            void
            "___arg1->blue = ___arg2;"))

(define x-color-flags
  (c-lambda (XColor*)
            char
            "___result = ___arg1->flags;"))

(define set-x-color-flags!
  (c-lambda (XColor* char)
            void
            "___arg1->flags = ___arg2;"))

(define x-color-pad
  (c-lambda (XColor*)
            char
            "___result = ___arg1->pad;"))

(define set-x-color-pad!
  (c-lambda (XColor* char)
            void
            "___arg1->pad = ___arg2;"))

(define xgc-values-function
  (c-lambda (XGCValues*)
            int
            "___result = ___arg1->function;"))

(define set-xgc-values-function!
  (c-lambda (XGCValues* int)
            void
            "___arg1->function = ___arg2;"))

(define xgc-values-plane-mask
  (c-lambda (XGCValues*)
            unsigned-long
            "___result = ___arg1->plane_mask;"))

(define set-xgc-values-plane-mask!
  (c-lambda (XGCValues* unsigned-long)
            void
            "___arg1->plane_mask = ___arg2;"))

(define xgc-values-foreground
  (c-lambda (XGCValues*)
            unsigned-long
            "___result = ___arg1->foreground;"))

(define set-xgc-values-foreground!
  (c-lambda (XGCValues* unsigned-long)
            void
            "___arg1->foreground = ___arg2;"))

(define xgc-values-background
  (c-lambda (XGCValues*)
            unsigned-long
            "___result = ___arg1->background;"))

(define set-xgc-values-background!
  (c-lambda (XGCValues* unsigned-long)
            void
            "___arg1->background = ___arg2;"))

(define xgc-values-line-width
  (c-lambda (XGCValues*)
            int
            "___result = ___arg1->line_width;"))

(define set-xgc-values-line-width!
  (c-lambda (XGCValues* int)
            void
            "___arg1->line_width = ___arg2;"))

(define xgc-values-line-style
  (c-lambda (XGCValues*)
            int
            "___result = ___arg1->line_style;"))

(define set-xgc-values-line-style!
  (c-lambda (XGCValues* int)
            void
            "___arg1->line_style = ___arg2;"))

(define xgc-values-cap-style
  (c-lambda (XGCValues*)
            int
            "___result = ___arg1->cap_style;"))

(define set-xgc-values-cap-style!
  (c-lambda (XGCValues* int)
            void
            "___arg1->cap_style = ___arg2;"))

(define xgc-values-join-style
  (c-lambda (XGCValues*)
            int
            "___result = ___arg1->join_style;"))

(define set-xgc-values-join-style!
  (c-lambda (XGCValues* int)
            void
            "___arg1->join_style = ___arg2;"))

(define xgc-values-fill-style
  (c-lambda (XGCValues*)
            int
            "___result = ___arg1->fill_style;"))

(define set-xgc-values-fill-style!
  (c-lambda (XGCValues* int)
            void
            "___arg1->fill_style = ___arg2;"))

(define xgc-values-fill-rule
  (c-lambda (XGCValues*)
            int
            "___result = ___arg1->fill_rule;"))

(define set-xgc-values-fill-rule!
  (c-lambda (XGCValues* int)
            void
            "___arg1->fill_rule = ___arg2;"))

(define xgc-values-arc-mode
  (c-lambda (XGCValues*)
            int
            "___result = ___arg1->arc_mode;"))

(define set-xgc-values-arc-mode!
  (c-lambda (XGCValues* int)
            void
            "___arg1->arc_mode = ___arg2;"))

(define xgc-values-tile
  (c-lambda (XGCValues*)
            Pixmap
            "___result = ___arg1->tile;"))

(define set-xgc-values-tile!
  (c-lambda (XGCValues* Pixmap)
            void
            "___arg1->tile = ___arg2;"))

(define xgc-values-stipple
  (c-lambda (XGCValues*)
            Pixmap
            "___result = ___arg1->stipple;"))

(define set-xgc-values-stipple!
  (c-lambda (XGCValues* Pixmap)
            void
            "___arg1->stipple = ___arg2;"))

(define xgc-values-ts-x-origin
  (c-lambda (XGCValues*)
            int
            "___result = ___arg1->ts_x_origin;"))

(define set-xgc-values-ts-x-origin!
  (c-lambda (XGCValues* int)
            void
            "___arg1->ts_x_origin = ___arg2;"))

(define xgc-values-ts-y-origin
  (c-lambda (XGCValues*)
            int
            "___result = ___arg1->ts_y_origin;"))

(define set-xgc-values-ts-y-origin!
  (c-lambda (XGCValues* int)
            void
            "___arg1->ts_y_origin = ___arg2;"))

(define xgc-values-font
  (c-lambda (XGCValues*)
            Font
            "___result = ___arg1->font;"))

(define set-xgc-values-font!
  (c-lambda (XGCValues* Font)
            void
            "___arg1->font = ___arg2;"))

(define xgc-values-subwindow-mode
  (c-lambda (XGCValues*)
            int
            "___result = ___arg1->subwindow_mode;"))

(define set-xgc-values-subwindow-mode!
  (c-lambda (XGCValues* int)
            void
            "___arg1->subwindow_mode = ___arg2;"))

(define xgc-values-graphics-exposures?
  (c-lambda (XGCValues*)
            bool
            "___result = ___arg1->graphics_exposures;"))

(define set-xgc-values-graphics-exposures!
  (c-lambda (XGCValues* bool)
            void
            "___arg1->graphics_exposures = ___arg2;"))

(define xgc-values-clip-x-origin
  (c-lambda (XGCValues*)
            int
            "___result = ___arg1->clip_x_origin;"))

(define set-xgc-values-clip-x-origin!
  (c-lambda (XGCValues* int)
            void
            "___arg1->clip_x_origin = ___arg2;"))

(define xgc-values-clip-y-origin
  (c-lambda (XGCValues*)
            int
            "___result = ___arg1->clip_y_origin;"))

(define set-xgc-values-clip-y-origin!
  (c-lambda (XGCValues* int)
            void
            "___arg1->clip_y_origin = ___arg2;"))

(define xgc-values-clip-mask
  (c-lambda (XGCValues*)
            Pixmap
            "___result = ___arg1->clip_mask;"))

(define set-xgc-values-clip-mask!
  (c-lambda (XGCValues* Pixmap)
            void
            "___arg1->clip_mask = ___arg2;"))

(define xgc-values-dash-offset
  (c-lambda (XGCValues*)
            int
            "___result = ___arg1->dash_offset;"))

(define set-xgc-values-dash-offset!
  (c-lambda (XGCValues* int)
            void
            "___arg1->dash_offset = ___arg2;"))

(define xgc-values-dashes
  (c-lambda (XGCValues*)
            char
            "___result = ___arg1->dashes;"))

(define set-xgc-values-dashes!
  (c-lambda (XGCValues* char)
            void
            "___arg1->dashes = ___arg2;"))

