var _s = 12;
var _tl = merge_colour(COL_METAL, c_white, 0.20);
draw_rectangle_colour(x - _s, y - _s, x + _s, y + _s, _tl, _tl, COL_METAL, COL_METAL, false);
draw_set_colour(merge_colour(COL_METAL, c_black, 0.35));
draw_circle(x, y, 4, false);
draw_set_colour(c_white);

for (var i = 0; i < level; i++) {
    draw_level_pips(x, y + 17, level);
}