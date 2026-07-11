draw_set_colour(c_white);
var _grace = ceil(global.grace_t / GAME_FPS);
draw_text(12, 10, "res " + string(global.resource) + "   wave " + string(global.wave) + "   water " + string_format(global.water_level, 1, 2) + "   grace " + string(_grace));

if (global.build == BUILD.NONE) draw_text(12, 30, "ZQSD move   SPACE dig   B build   click a building = upgrade");
else if (global.build == BUILD.PLACING) draw_text(12, 30, "click  place      right-click  cancel");
if (global.build == BUILD.MENU) {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    draw_set_alpha(0.6); draw_set_colour(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);
    var _n = array_length(global.build_defs);
    var _bw = 140; var _bh = 90; var _gap = 12;
    var _total = _n * _bw + (_n - 1) * _gap;
    var _x0 = _gw / 2 - _total / 2;
    var _by = _gh / 2 - _bh / 2;
    var _mgx = device_mouse_x_to_gui(0);
    var _mgy = device_mouse_y_to_gui(0);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(c_white);
    draw_text(_gw / 2, _by - 34, "BUILD - time paused   (ESC to cancel)");
    for (var i = 0; i < _n; i++) {
        var _bx = _x0 + i * (_bw + _gap);
        var _def = global.build_defs[i];
        var _over = (_mgx > _bx && _mgx < _bx + _bw && _mgy > _by && _mgy < _by + _bh);
        var _afford = (global.resource >= _def.cost);
        var _base = (_def.obj == obj_pump) ? COL_METAL : COL_WOOD;
        draw_set_colour(_over ? merge_colour(_base, c_white, 0.25) : merge_colour(_base, c_black, 0.35));
        draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);
        draw_set_colour(_afford ? c_white : make_colour_rgb(210, 120, 120));
        draw_text(_bx + _bw / 2, _by + _bh / 2 - 10, _def.name);
        draw_text(_bx + _bw / 2, _by + _bh / 2 + 12, string(_def.cost) + " res");
    }
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
if (global.build == BUILD.UPGRADE && instance_exists(global.upg_bld)) {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    draw_set_alpha(0.6); draw_set_colour(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);

    var _stats = upg_stats(global.upg_bld);
    var _n = array_length(_stats);
    var _rw = 320; var _rh = 34; var _sp = 8;
    var _px = _gw / 2 - _rw / 2;
    var _py = _gh / 2 - (_n * (_rh + _sp)) / 2;
    var _mgx = device_mouse_x_to_gui(0);
    var _mgy = device_mouse_y_to_gui(0);

    draw_set_colour(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(_gw / 2, _py - 26, ((global.upg_bld.object_index == obj_pump) ? "PUMP" : "TURRET") + " upgrade  -  time paused");

    for (var i = 0; i < _n; i++) {
        var _ry = _py + i * (_rh + _sp);
        var _over = (_mgx > _px && _mgx < _px + _rw && _mgy > _ry && _mgy < _ry + _rh);
        var _maxed = (_stats[i].lvl >= BUILD_MAX_LEVEL);
        var _afford = (global.resource >= _stats[i].cost);
        draw_set_colour(_maxed ? make_colour_rgb(55, 55, 60) : (_over ? merge_colour(COL_WOOD, c_white, 0.25) : merge_colour(COL_WOOD, c_black, 0.35)));
        draw_rectangle(_px, _ry, _px + _rw, _ry + _rh, false);
        draw_set_colour((_afford || _maxed) ? c_white : make_colour_rgb(210, 120, 120));
        draw_set_halign(fa_left);
        draw_text(_px + 14, _ry + _rh / 2, _stats[i].label + "   lvl " + string(_stats[i].lvl));
        draw_set_halign(fa_right);
        draw_text(_px + _rw - 14, _ry + _rh / 2, _maxed ? "MAX" : string(_stats[i].cost));
    }

    draw_set_colour(c_white);
    draw_set_halign(fa_center);
    draw_text(_gw / 2, _py + _n * (_rh + _sp) + 18, "click a stat to upgrade  -  ESC / click outside to close");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

if (global.state == GAME_STATE.OVER) {
    draw_set_halign(fa_center); draw_set_valign(fa_middle);
    draw_text(display_get_gui_width() / 2, display_get_gui_height() / 2, "SUBMERGED");
    draw_set_halign(fa_left); draw_set_valign(fa_top);
}

if (global.grace_t <= 0 && wave_to_spawn == 0 && instance_number(obj_enemy) == 0) {
    draw_text(12, 50, "wave cleared - next in " + string(ceil(intermission_t / GAME_FPS)));
}

var _rise = wave_rise_rate(global.wave);
var _net = _rise - global.pump_capacity;

draw_set_colour(c_white);
draw_text(12, 90, "pumping " + string_format(global.pump_capacity, 1, 3) + "     tide " + string_format(_rise, 1, 3));

draw_set_colour(_net > 0 ? c_red : c_lime);
draw_text(12, 110, (_net > 0 ? "RISING  " : "RECEDING  ") + string_format(abs(_net), 1, 3) + "/s");
draw_set_colour(c_white);