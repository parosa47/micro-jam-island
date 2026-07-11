var _range = base_range + (range_lvl - 1) * 30;
draw_set_alpha(0.22);
draw_set_colour(COL_SAND_WET);
draw_circle(x, y, _range, false);
draw_set_alpha(1);
draw_set_colour(merge_colour(COL_SAND_WET, c_black, 0.3));
draw_circle(x, y, 12, false);
draw_set_colour(c_white);
draw_level_pips(x, y + 17, slow_lvl + range_lvl - 1);