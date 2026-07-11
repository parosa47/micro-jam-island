draw_set_colour(c_white);
var _grace = ceil(global.grace_t / GAME_FPS);
draw_text(12, 10, "res " + string(global.resource) + "   wave " + string(global.wave) + "   water " + string_format(global.water_level, 1, 2) + "   grace " + string(_grace));

if (global.build == BUILD.NONE) draw_text(12, 30, "ZQSD move   SPACE dig   B build");
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