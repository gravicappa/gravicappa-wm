#include <xcb/xcb.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

#define NFONTS 2
const char *fontlist[] = {
  "-misc-fixed-bold-r-*-*-18-*-*-*-*-*-iso10646-1",
  "fixed"
};

enum {
  COLOUR_BG = 0x700000,
  COLOUR_FG = 0xffffff,
  COLOUR_SEL_FG = 0xffffff,
  COLOUR_SEL_BG = 0x000000,
  BORDER = 4
};

struct node {
  struct node *next;
  xcb_window_t win;
  xcb_gcontext_t gc;
};

struct font {
	xcb_font_t fn;
	xcb_query_font_reply_t *info;
	xcb_charinfo_t *tbl;
	int height;
	int range[2];
};

xcb_connection_t *c;
struct font fonts[NFONTS];
struct node *windows;

void release();

void
die(const char *fmt, ...)
{
	va_list args;
	va_start(args, fmt);
	vfprintf(stderr, fmt, args);
	va_end(args);
	release();
	exit(1);
}

int
strn_width(xcb_gcontext_t gc, int len, const char *str)
{
	int i, ch, w = 0;
	struct font *fn = &fonts[0];
	for (i = 0; i < len && (ch = str[i]); ++i)
		w += ((ch > fn->range[0] && ch < fn->range[1]) 
					? fn->tbl[ch - fn->range[0]].character_width : 0);
	return w;
}

void
draw_strn(struct node *node, int len, const char *str, int x, int y)
{
	struct font *fn = &fonts[0];

	xcb_change_gc(c, node->gc, XCB_GC_FONT, &fn->fn);
	y += fn->height - fn->info->font_descent;
	xcb_image_text_8(c, len, node->win, node->gc, x, y, str);
}

xcb_screen_t *
screen_from_root(xcb_window_t root)
{
  xcb_screen_iterator_t it;
  xcb_screen_t *s;
  it = xcb_setup_roots_iterator(xcb_get_setup(c));
  s = it.data;
  for (; it.rem; xcb_screen_next(&it))
    if (it.data->root == root)
      return it.data;
  return s;
}

int
get_win_info(xcb_window_t win, int r[4], xcb_screen_t **scr)
{
  xcb_get_geometry_reply_t *geom;
  xcb_get_geometry_cookie_t cookie = xcb_get_geometry(c, win);
  geom = xcb_get_geometry_reply(c, cookie, 0);
  if (!geom)
    return -1;
  r[0] = geom->x;
  r[1] = geom->y;
  r[2] = geom->width;
  r[3] = geom->height;
  free(geom);
  *scr = screen_from_root(win);
  return 0;
}

void
init_fonts()
{
	int h, maxh, i, n = sizeof(fonts) / sizeof(fonts[0]);
	xcb_query_font_cookie_t req;
	xcb_query_font_reply_t *info;
	xcb_void_cookie_t cookie;
	xcb_font_t font;

	maxh = -1;
	for (i = 0; i < n; ++i) {
		font = xcb_generate_id(c);
		cookie = xcb_open_font_checked(c, font, strlen(fontlist[i]), fontlist[i]);
		if (xcb_request_check(c, cookie))
			die("Could not load font '%s'.\n", fontlist[i]);
		req = xcb_query_font(c, font);
		info = xcb_query_font_reply(c, req, 0);
		fonts[i].fn = font;
		fonts[i].info = info;
		fonts[i].tbl = xcb_query_font_char_infos(info);
		fonts[i].range[0] = info->min_byte1 << 8 | info->min_char_or_byte2;
		fonts[i].range[1] = info->max_byte1 << 8 | info->max_char_or_byte2;
		h = info->font_ascent + info->font_descent;
		maxh = (maxh > h) ? maxh : h;
	}
	for (i = 0; i < n; ++i)
		fonts[i].height = maxh;
}

int
mk_num_window(xcb_screen_t *scr, int r[4], int num)
{
  struct node *node;
  struct xcb_rectangle_t rect = {0};
	unsigned int mask, val[4], nstr;
  char str[10];

  if ((r[2] <= 1 && r[3] <= 1)
      || r[0] > scr->width_in_pixels || r[1] > scr->height_in_pixels)
    return -1;

  node = malloc(sizeof(struct node));
  if (!node)
    die("Cannot allocate memory");

  nstr = snprintf(str, sizeof(str), "%d", num);
	node->win = xcb_generate_id(c);
  rect.x = (r[0] >= 0) ? r[0] : 0;
  rect.y = (r[1] >= 0) ? r[1] : 0;
  rect.width = 100;
  rect.height = 100;
	mask = XCB_CW_BACK_PIXEL | XCB_CW_OVERRIDE_REDIRECT | XCB_CW_EVENT_MASK;
	val[0] = scr->white_pixel;
	val[1] = 1;
	val[2] = XCB_EVENT_MASK_EXPOSURE | XCB_EVENT_MASK_KEY_PRESS;
	xcb_create_window(c, scr->root_depth, node->win, scr->root,
                    rect.x, rect.y, rect.width, rect.height, 0,
                    XCB_WINDOW_CLASS_INPUT_OUTPUT, scr->root_visual, mask,
                    val);
	xcb_map_window(c, node->win);
	mask = XCB_GC_FOREGROUND | XCB_GC_BACKGROUND | XCB_GC_GRAPHICS_EXPOSURES;
	val[0] = scr->black_pixel;
	val[1] = scr->white_pixel;
	val[2] = 0;
	node->gc = xcb_generate_id(c);
	xcb_create_gc(c, node->gc, node->win, mask, val);
  val[0] = strn_width(node->gc, nstr, str) + BORDER * 2;
  val[1] = fonts[0].height + BORDER * 2;
  mask = XCB_CONFIG_WINDOW_WIDTH | XCB_CONFIG_WINDOW_HEIGHT;
	xcb_configure_window(c, node->win, mask, val);
  val[0] = COLOUR_BG;
  val[1] = 0;
  xcb_change_gc(c, node->gc, XCB_GC_FOREGROUND, val);
  xcb_change_gc(c, node->gc, XCB_GC_BACKGROUND, val);
  rect.x = rect.y = 0;
  xcb_poly_fill_rectangle (c, node->win, node->gc, 1, &rect);
  val[0] = COLOUR_FG;
  xcb_change_gc(c, node->gc, XCB_GC_FOREGROUND, val);
  draw_strn(node, nstr, str, BORDER, BORDER);
	xcb_grab_keyboard(c, 1, node->win, XCB_CURRENT_TIME, XCB_GRAB_MODE_ASYNC,
										XCB_GRAB_MODE_ASYNC);
  node->next = windows;
  windows = node;
  return 0;
}

void
release()
{
	int i, n = sizeof(fonts) / sizeof(fonts[0]);
  struct node *node, *nodenext;

	xcb_ungrab_keyboard(c, XCB_CURRENT_TIME);
	for (i = 0; i < n; ++i) {
		if (fonts[i].info)
			free(fonts[i].info);
		if (fonts[i].fn)
			xcb_close_font(c, fonts[i].fn);
	}
  for (node = windows; node; node = nodenext) {
    nodenext = node->next;
    if (node->win)
      xcb_destroy_window(c, node->win);
    if (node->gc)
      xcb_free_gc(c, node->gc);
    free(node);
  }
  windows = 0;
	if (c)
		xcb_disconnect(c);
}

void
event_loop()
{
  xcb_generic_event_t *ev;
  int go = 1;

  while (go)
    while (go && (ev = xcb_poll_for_event(c)))
      switch (ev->response_type) {
      case XCB_KEY_PRESS: go = 0; break;
      }
      free(ev);
}

int
main()
{
  int r[4], i = 1;
  unsigned int win;
  char buf[256];
  xcb_screen_t *s;

  c = xcb_connect(0, 0);
  if (!c)
    die("Cannot open display.\n");
  init_fonts();
  while (fgets(buf, sizeof(buf), stdin))
    if (sscanf(buf, "%u", &win) == 1
        && !get_win_info(win, r, &s) && !mk_num_window(s, r, i))
      ++i;
  if (i) {
    xcb_flush(c);
    event_loop();
  }
  release();
  return 0;
}
