draw_set_colour(c_white);
var _grace = ceil(global.grace_t / GAME_FPS);
draw_text(12, 10, "res " + string(global.resource) + "   wave " + string(global.wave) + "   water " + string_format(global.water_level, 1, 2) + "   grace " + string(_grace));

if (global.build == BUILD.NONE) draw_text(12, 30, "ZQSD move   SPACE dig   B build   click a building = upgrade");
if (global.build == BUILD.NONE) {
    var _hp = instance_nearest(mouse_x, mouse_y, obj_pump);
    var _ht = instance_nearest(mouse_x, mouse_y, obj_turret);
    var _pk = noone; var _hd = 22;
    if (_hp != noone && point_distance(mouse_x, mouse_y, _hp.x, _hp.y) < _hd) { _pk = _hp; _hd = point_distance(mouse_x, mouse_y, _hp.x, _hp.y); }
    if (_ht != noone && point_distance(mouse_x, mouse_y, _ht.x, _ht.y) < _hd) { _pk = _ht; }
    if (_pk != noone) {
        var _lv = _pk.level;
        var _s = (_lv < BUILD_MAX_LEVEL) ? ("lvl " + string(_lv) + "  -  upgrade: " + string(round(_pk.base_cost * _lv * UPGRADE_COST_MULT))) : ("lvl " + string(_lv) + "  -  MAX");
        draw_text(12, 70, _s);
    }
}
else if (global.build == BUILD.PLACING) draw_text(12, 30, "click  place      right-click  cancel");

if (global.build == BUILD.MENU) {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    draw_set_alpha(0.6); draw_set_colour(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);

    var _bw = 200; var _bh = 90; var _gap = 40;
    var _by = _gh / 2 - _bh / 2;
    var _bx1 = _gw / 2 - _bw - _gap / 2;
    var _bx2 = _gw / 2 + _gap / 2;
    var _mgx = device_mouse_x_to_gui(0);
    var _mgy = device_mouse_y_to_gui(0);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(c_white);
    draw_text(_gw / 2, _by - 34, "BUILD - time paused   (ESC to cancel)");

    var _over1 = (_mgx > _bx1 && _mgx < _bx1 + _bw && _mgy > _by && _mgy < _by + _bh);
    draw_set_colour(_over1 ? COL_METAL : merge_colour(COL_METAL, c_black, 0.4));
    draw_rectangle(_bx1, _by, _bx1 + _bw, _by + _bh, false);
    draw_set_colour(c_white);
    draw_text(_bx1 + _bw / 2, _by + _bh / 2 - 10, "Pump");
    draw_text(_bx1 + _bw / 2, _by + _bh / 2 + 12, string(PUMP_COST) + " res");

    var _over2 = (_mgx > _bx2 && _mgx < _bx2 + _bw && _mgy > _by && _mgy < _by + _bh);
    draw_set_colour(_over2 ? COL_WOOD : merge_colour(COL_WOOD, c_black, 0.4));
    draw_rectangle(_bx2, _by, _bx2 + _bw, _by + _bh, false);
    draw_set_colour(c_white);
    draw_text(_bx2 + _bw / 2, _by + _bh / 2 - 10, "Turret");
    draw_text(_bx2 + _bw / 2, _by + _bh / 2 + 12, string(TURRET_COST) + " res");

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