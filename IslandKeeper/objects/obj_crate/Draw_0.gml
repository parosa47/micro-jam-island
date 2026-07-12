var _s = 10;
var _lt = merge_colour(COL_WOOD, c_white, 0.15);
draw_rectangle_colour(x - _s, y - _s, x + _s, y + _s, _lt, _lt, COL_WOOD, COL_WOOD, false);
draw_set_colour(merge_colour(COL_WOOD, c_black, 0.4));
draw_line_width(x - _s, y - _s, x + _s, y + _s, 2);
draw_line_width(x - _s, y + _s, x + _s, y - _s, 2);
draw_rectangle(x - _s, y - _s, x + _s, y + _s, true);
draw_set_colour(c_white);