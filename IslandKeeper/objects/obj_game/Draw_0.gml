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
    var _tr = type_base_range(global.build_obj);
    if (_tr > 0) {
        draw_set_alpha(0.10); draw_set_colour(c_white);
        draw_circle(mouse_x, mouse_y, _tr, false);
    }
    draw_set_alpha(0.5);
    draw_set_colour(global.build_valid ? c_lime : c_red);
    draw_rectangle(mouse_x - 12, mouse_y - 12, mouse_x + 12, mouse_y + 12, false);
    draw_set_alpha(1);
    draw_set_colour(c_white);
}

if (global.state == GAME_STATE.PLAY && global.build == BUILD.NONE && instance_exists(hover_bld)) {
    if (hover_bld.kind == "offensive" || hover_bld.kind == "aura") {
        var _r = hover_bld.base_range + (hover_bld.range_lvl - 1) * 30;
        draw_set_colour(c_white);
        draw_set_alpha(0.10); draw_circle(hover_bld.x, hover_bld.y, _r, false);
        draw_set_alpha(0.45); draw_circle(hover_bld.x, hover_bld.y, _r, true);
        draw_set_alpha(1);
    }
    draw_set_halign(fa_center);
    draw_set_colour(c_white);
    draw_text(hover_bld.x, hover_bld.y - 22, "click to upgrade");
    draw_set_halign(fa_left);
}