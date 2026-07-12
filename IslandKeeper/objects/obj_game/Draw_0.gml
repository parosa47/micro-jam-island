draw_set_colour(COL_SEA_DEEP);
draw_rectangle(0, 0, room_width, room_height, false);

var _exposed = island_r * (1 - global.water_level);

draw_blob(island_x, island_y, island_r, island_coast, island_n, COL_SAND);
draw_blob(island_x, island_y, island_r * 0.58, island_coast, island_n, COL_VEG_LIGHT, _exposed, island_coast);

for (var _i = 0; _i < array_length(island_deco); _i++) {
    var _dc = island_deco[_i];
    if (_dc.palm) continue;
    var _fade = clamp((_exposed - _dc.dist) / 20, 0, 1);
    if (_fade <= 0) continue;
    var _dx = island_x + lengthdir_x(_dc.dist, _dc.a);
    var _dy = island_y + lengthdir_y(_dc.dist, _dc.a);
    draw_set_alpha(_fade);
    draw_set_colour(COL_VEG_DARK);
    draw_circle(_dx, _dy, _dc.s * 0.5, false);
    draw_set_alpha(1);
}
for (var _i = 0; _i < array_length(island_deco); _i++) {
    var _dc = island_deco[_i];
    if (!_dc.palm) continue;
    var _fade = clamp((_exposed - _dc.dist) / 20, 0, 1);
    if (_fade <= 0) continue;
    var _dx = island_x + lengthdir_x(_dc.dist, _dc.a);
    var _dy = island_y + lengthdir_y(_dc.dist, _dc.a);
    draw_set_alpha(_fade);
    draw_palm(_dx, _dy, _dc.s);
    draw_set_alpha(1);
}
var _shore = _exposed;
if (_exposed > island_r * 0.58) {
    draw_ring(island_x, island_y, _exposed, _exposed + 14, island_coast, island_n, COL_SAND_WET);
    _shore = _exposed + 14;
}
draw_ring(island_x, island_y, _shore,        _exposed + 24,  island_coast, island_n, COL_FOAM);
draw_ring(island_x, island_y, _exposed + 24, _exposed + 44,  island_coast, island_n, COL_WATER);
draw_ring(island_x, island_y, _exposed + 44, _exposed + 66,  island_coast, island_n, merge_colour(COL_SEA_DEEP, COL_WATER, 0.55));
draw_ring(island_x, island_y, _exposed + 66, island_r * 1.6, island_coast, island_n, COL_SEA_DEEP);
draw_set_colour(c_white);

if (global.build == BUILD.PLACING) {
    var _cx = grid_snap(mouse_x);
    var _cy = grid_snap(mouse_y);

    draw_set_colour(c_white);
    draw_set_alpha(0.06);
    for (var gx = 0; gx <= room_width; gx += CELL) draw_line(gx, 0, gx, room_height);
    for (var gy = 0; gy <= room_height; gy += CELL) draw_line(0, gy, room_width, gy);
    draw_set_alpha(1);

    var _tr = type_base_range(global.build_obj);
    if (_tr > 0) {
        draw_set_alpha(0.10);
        draw_circle(_cx, _cy, _tr, false);
    }
    draw_set_alpha(0.5);
    draw_set_colour(global.build_valid ? c_lime : c_red);
    draw_rectangle(_cx - CELL * 0.5 + 2, _cy - CELL * 0.5 + 2, _cx + CELL * 0.5 - 2, _cy + CELL * 0.5 - 2, false);
    draw_set_alpha(1);
    draw_set_colour(c_white);
}

if (global.state == GAME_STATE.PLAY && global.build == BUILD.NONE && instance_exists(hover_bld)) {
    if (hover_bld.kind == "offensive") {
        var _r = hover_bld.base_range + (hover_bld.range_lvl - 1) * 30;
        draw_set_colour(c_white);
        draw_set_alpha(0.10); draw_circle(hover_bld.x, hover_bld.y, _r, false);
        draw_set_alpha(0.45); draw_circle(hover_bld.x, hover_bld.y, _r, true);
        draw_set_alpha(1);
    }
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_colour(c_white);
    draw_text(hover_bld.x, hover_bld.y - 20, "L-click: upgrade    R-click: sell");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}