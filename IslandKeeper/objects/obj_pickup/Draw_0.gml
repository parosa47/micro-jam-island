draw_set_colour(COL_GEM);
var _s = 6;
draw_triangle(x, y - _s, x - _s, y, x + _s, y, false);
draw_triangle(x, y + _s, x - _s, y, x + _s, y, false);
draw_set_colour(c_white);