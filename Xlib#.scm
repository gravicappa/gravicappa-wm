;==============================================================================

; -file: "-xlib#.scm", -time-stamp: <2008-11-24 16:19:08 feeley>

; -copyright (c) 2005-2008 by -marc -feeley, -all -rights -reserved.

;==============================================================================

(##namespace ("Xlib#"

; procedures and variables
button1-motion-mask
button2-motion-mask
button3-motion-mask
button4-motion-mask
button5-motion-mask
button-motion-mask
button-press-mask
button-release-mask
circulate-notify
circulate-request
client-message
colormap-change-mask
colormap-notify
configure-notify
configure-request
create-notify
destroy-notify
enter-window-mask
expose
exposure-mask
focus-change-mask
focus-in
focus-out
x-gc-arc-mode
x-gc-background
x-gc-cap-style
x-gc-clip-mask
x-gc-clip-x-origin
x-gc-clip-y-origin
x-gc-dash-list
x-gc-dash-offset
x-gc-fill-rule
x-gc-fill-style
x-gc-font
x-gc-foreground
x-gc-function
x-gc-graphics-exposures
x-gc-join-style
x-gc-line-style
x-gc-line-width
x-gc-plane-mask
x-gc-stipple
x-gc-subwindow-mode
x-gc-tile
x-gc-tile-stip-x-origin
x-gc-tile-stip-y-origin
graphics-expose
gravity-notify
key-press-mask
key-release-mask
keymap-notify
keymap-state-mask
leave-window-mask
map-notify
map-request
mapping-notify
no-event-mask
no-expose
owner-grab-button-mask
pointer-motion-hint-mask
pointer-motion-mask
property-change-mask
property-notify
reparent-notify
resize-redirect-mask
resize-request
selection-clear
selection-notify
selection-request
structure-notify-mask
substructure-notify-mask
substructure-redirect-mask
unmap-notify
visibility-change-mask
visibility-notify
x-alloc-color
x-black-pixel
x-change-gc
x-check-mask-event
x-pending
x-next-event
x-clear-window
x-close-display
x-color-blue
x-color-blue-set!
x-color-green
x-color-green-set!
x-color-pixel
x-color-pixel-set!
x-color-red
x-color-red-set!
x-connection-number
x-create-gc
x-create-simple-window
x-default-colormap-of-screen
x-default-gc
x-default-gc-of-screen
x-default-root-window
x-default-screen
x-screen-count
x-default-visual
x-default-visual-of-screen
x-draw-string
x-fill-arc
x-fill-rectangle
x-flush
x-sync
x-font-struct-ascent
x-font-struct-descent
x-font-struct-fid
x-gc-values-background
x-gc-values-background-set!
x-gc-values-font
x-gc-values-font-set!
x-gc-values-foreground
x-gc-values-foreground-set!
x-get-gc-values
x-load-font
x-load-query-font
x-map-window
x-open-display
x-display-width
x-display-heigth
x-parse-color
x-query-font
x-root-window
x-root-window-of-screen
x-screen-of-display
x-select-input
x-text-width
x-white-pixel

x-configure-window
x-move-resize-window
x-move-window
x-resize-window

x-any-event-type
x-any-event-serial
x-any-event-send-event
x-any-event-display
x-any-event-window
x-key-event-root
x-key-event-subwindow
x-key-event-time
x-key-event-x
x-key-event-y
x-key-event-x-root
x-key-event-y-root
x-key-event-state
x-key-event-keycode
x-key-event-same-screen
x-button-event-root
x-button-event-subwindow
x-button-event-time
x-button-event-x
x-button-event-y
x-button-event-x-root
x-button-event-y-root
x-button-event-state
x-button-event-button
x-button-event-same-screen
x-motion-event-root
x-motion-event-subwindow
x-motion-event-time
x-motion-event-x
x-motion-event-y
x-motion-event-x-root
x-motion-event-y-root
x-motion-event-state
x-motion-event-is-hint
x-motion-event-same-screen
x-crossing-event-root
x-crossing-event-subwindow
x-crossing-event-time
x-crossing-event-x
x-crossing-event-y
x-crossing-event-x-root
x-crossing-event-y-root
x-crossing-event-mode
x-crossing-event-detail
x-crossing-event-same-screen
x-crossing-event-focus
x-crossing-event-state

convert-x-event
make-x-color-box
make-x-gc-values-box
wait-x11-event
))

;==============================================================================
