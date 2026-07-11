draw_set_colour(COL_SEA_DEEP);
draw_rectangle(0, 0, room_width, room_height, false);

var _exposed = island_r * (1 - global.water_level);

draw_set_colour(COL_WATER);
draw_circle(island_x, island_y, _exposed + 26, false);
draw_set_colour(COL_FOAM);
draw_circle(island_x, island_y, _exposed + 12, false);
draw_set_colour(COL_SAND_WET);
draw_circle(island_x, island_y, _exposed + 5, false);
draw_set_colour(COL_SAND);
draw_circle(island_x, island_y, _exposed, false);
draw_set_colour(c_white);