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

if (global.state == GAME_STATE.PLAY && global.build == BUILD.NONE && instance_exists(hover_bld)) {
    var _bx = hover_bld.x;
    var _by = hover_bld.y - 24;
    draw_set_halign(fa_center);
    draw_set_colour(c_white);
    if (hover_bld.object_index == obj_pump) {
        draw_text(_bx, _by, (hover_bld.level < BUILD_MAX_LEVEL) ? ("L-click: upgrade " + string(round(hover_bld.base_cost * hover_bld.level * UPGRADE_COST_MULT))) : "MAX");
    } else {
        var _sd = (hover_bld.dmg_lvl < BUILD_MAX_LEVEL) ? ("L: +DMG " + string(round(hover_bld.base_cost * hover_bld.dmg_lvl * UPGRADE_COST_MULT))) : "DMG MAX";
        var _sr = (hover_bld.range_lvl < BUILD_MAX_LEVEL) ? ("R: +RNG " + string(round(hover_bld.base_cost * hover_bld.range_lvl * UPGRADE_COST_MULT))) : "RNG MAX";
        draw_text(_bx, _by - 13, _sd);
        draw_text(_bx, _by, _sr);
    }
    draw_set_halign(fa_left);
}