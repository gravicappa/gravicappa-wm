# Installation

Enter the following commands to build and install executable
**gravicappa-wm**:

    make
    make destdir=/usr install

If your gsc executable has another name (e.g. to avoid name clash with
ghostscript) specify gsc parameter:

    make GSC=gambit-gsc

# Running gravicappa-wm

See included `sample/dotxinitrc` which shows possible way of running window
manager. Those commands can be added into your `.xinitrc`.

**gravicappa-wm** reads `~/.gravicappa-wm.scm` configuration file which is a
scheme source. Sample can be taken from sample/gravicappa-wm.scm.

# Customizing

> TODO

## Hooks
### (shutdown-hook)

It is called on exit.

### (update-tag-hook)

It is called when taglist is updated.

### (mwin-create-hook client classname)

It is called with new managed window (`mwin`) is created before it is mapped.
Automatic tagging can be performed here. `classname` is cons of strings with
x11 window class information.

### (tag-hook client tag)

It is called when `client` is tagged by `tag`.

### (untag-hook client tag)

It is called when `client` is untagged from `tag`.
