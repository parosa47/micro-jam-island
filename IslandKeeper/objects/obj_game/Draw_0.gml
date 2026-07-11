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

if (global.build == BUILD.PLACING) {
    if (global.build_obj == obj_turret) {
        draw_set_alpha(0.12);
        draw_set_colour(c_white);
        draw_circle(mouse_x, mouse_y, TURRET_RANGE, false);
    }
    draw_set_alpha(0.5);
    draw_set_colour(global.build_valid ? c_lime : c_red);
    draw_rectangle(mouse_x - 12, mouse_y - 12, mouse_x + 12, mouse_y + 12, false);
    draw_set_alpha(1);
    draw_set_colour(c_white);
}