var _s = 12;
var _tl = merge_colour(COL_WOOD, c_white, 0.20);
draw_rectangle_colour(x - _s, y - _s, x + _s, y + _s, _tl, _tl, COL_WOOD, COL_WOOD, false);
var _e = instance_nearest(x, y, obj_enemy);
var _ang = (_e != noone) ? point_direction(x, y, _e.x, _e.y) : 0;
draw_set_colour(merge_colour(COL_WOOD, c_black, 0.35));
draw_line_width(x, y, x + lengthdir_x(16, _ang), y + lengthdir_y(16, _ang), 5);
draw_set_colour(c_white);

for (var i = 0; i < level; i++) {
   draw_level_pips(x, y + 17, dmg_lvl + range_lvl - 1);
}