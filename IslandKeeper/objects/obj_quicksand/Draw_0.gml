var _s = CELL * 0.5 - 1;
var _dk = merge_colour(COL_SAND_WET, c_black, 0.35);
draw_rectangle_colour(x - _s, y - _s, x + _s, y + _s, COL_SAND_WET, COL_SAND_WET, _dk, _dk, false);
draw_set_colour(merge_colour(COL_SAND_WET, c_black, 0.5));
draw_circle(x - 4, y - 3, 1.5, false);
draw_circle(x + 5, y + 4, 1.5, false);
draw_circle(x + 2, y - 5, 1.5, false);
draw_set_colour(c_white);
draw_level_pips(x, y + 17, slow_lvl);