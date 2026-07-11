var _s = CELL * 0.5 - 1;
var _lt = make_colour_rgb(122, 122, 132);
var _dk = make_colour_rgb(88, 88, 98);
draw_rectangle_colour(x - _s, y - _s, x + _s, y + _s, _lt, _lt, _dk, _dk, false);
draw_set_colour(merge_colour(_dk, c_black, 0.25));
draw_rectangle(x - _s, y - _s, x + _s, y + _s, true);
draw_set_colour(c_white);