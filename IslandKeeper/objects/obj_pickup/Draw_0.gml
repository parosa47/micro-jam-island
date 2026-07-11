var _s = 6;
draw_set_colour(merge_colour(COL_GEM, c_black, 0.65));
draw_triangle(x, y - _s - 2, x - _s - 2, y, x + _s + 2, y, false);
draw_triangle(x, y + _s + 2, x - _s - 2, y, x + _s + 2, y, false);
draw_set_colour(COL_GEM);
draw_triangle(x, y - _s, x - _s, y, x + _s, y, false);
draw_triangle(x, y + _s, x - _s, y, x + _s, y, false);
draw_set_colour(c_white);