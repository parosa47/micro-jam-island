draw_set_font(fnt_ui);
draw_set_colour(c_white);
var _grace = ceil(global.grace_t / GAME_FPS);
var _rise = wave_rise_rate(global.wave);
var _net = _rise - global.pump_capacity;

if (global.grace_t > 0) {
    draw_label(14, 12, "Wave 1 in " + string(ceil(global.grace_t / GAME_FPS)) + "s   -   Salvage " + string(global.resource), fa_left);
} else {
    draw_label(14, 12, "Wave " + string(global.wave) + "   -   Salvage " + string(global.resource), fa_left);
}
draw_label(14, 46, "Flood " + string_format(global.water_level * 100, 1, 0) + "%   -   " + (_net > 0 ? "RISING" : "RECEDING"), fa_left);

if (global.grace_t <= 0 && wave_to_spawn == 0 && instance_number(obj_enemy) == 0) {
    draw_label(display_get_gui_width() / 2, 12, "Wave cleared - next in " + string(ceil(intermission_t / GAME_FPS)), fa_center);
}

if (global.state == GAME_STATE.PLAY) {
    var _gx = 14, _gy = 104, _gwid = 220, _ghei = 14;
    var _next = wave_rise_rate(global.wave + 1);
    var _scale = _next * 1.25 + 0.0001;
    var _need = max(0, ceil((_next - global.pump_capacity) / PUMP_FLOW));

    draw_set_alpha(0.55); draw_set_colour(c_black);
    draw_rectangle(_gx - 8, _gy - 24, _gx + _gwid + 8, _gy + _ghei + 30, false);
    draw_set_alpha(1);

    draw_set_font(fnt_ui);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_colour(c_white);
    draw_text(_gx, _gy - 22, "Pumping vs next tide");

    draw_set_colour(make_colour_rgb(70, 170, 90));
    draw_rectangle(_gx, _gy, _gx + _gwid * clamp(global.pump_capacity / _scale, 0, 1), _gy + _ghei, false);
    draw_set_colour(merge_colour(c_black, c_white, 0.35));
    draw_rectangle(_gx, _gy, _gx + _gwid, _gy + _ghei, true);

    var _rx = _gx + _gwid * clamp(_next / _scale, 0, 1);
    draw_set_colour(COL_ALERT);
    draw_line_width(_rx, _gy - 4, _rx, _gy + _ghei + 4, 2);

    draw_set_colour((_need > 0) ? make_colour_rgb(235, 205, 90) : make_colour_rgb(120, 220, 140));
    draw_text(_gx, _gy + _ghei + 6, (_need > 0) ? ("Next wave: +" + string(_need) + " pump" + (_need > 1 ? "s" : "")) : "Next wave: covered");
    draw_set_colour(c_white);
}

if (global.state == GAME_STATE.PLAY && instance_exists(obj_player)) {
    var _hw = 170, _hh = 12;
    var _hx = display_get_gui_width() - _hw - 16;
    var _hy = 18;
    var _frac = clamp(obj_player.hp / obj_player.hp_max, 0, 1);
    draw_set_font(fnt_ui);
    draw_set_halign(fa_right);
    draw_set_valign(fa_middle);
    draw_set_colour(c_white);
    draw_text(_hx - 8, _hy + _hh / 2, "HP");
    draw_set_colour(make_colour_rgb(50, 18, 18));
    draw_rectangle(_hx, _hy, _hx + _hw, _hy + _hh, false);
    draw_set_colour(merge_colour(make_colour_rgb(200, 60, 50), make_colour_rgb(90, 200, 90), _frac));
    draw_rectangle(_hx, _hy, _hx + _hw * _frac, _hy + _hh, false);
    draw_set_colour(merge_colour(c_black, c_white, 0.3));
    draw_rectangle(_hx, _hy, _hx + _hw, _hy + _hh, true);
    draw_set_colour(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

if (array_length(global.msg_queue) > 0) {
    var _m = global.msg_queue[0];
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    var _bw = 660;
    var _bx = _gw / 2 - _bw / 2;
    var _by = _gh - 114;
    var _bh = 80;

    draw_set_alpha(0.75); draw_set_colour(c_black);
    draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);
    draw_set_alpha(1);
    draw_set_colour(merge_colour(c_black, c_white, 0.25));
    draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, true);

    draw_set_font(fnt_ui);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_colour((_m.spk == "RADIO") ? COL_FOAM : COL_SAND);
    draw_text(_bx + 16, _by + 8, _m.spk);
    draw_set_colour(c_white);
    var _shown = string_copy(_m.txt, 1, floor(global.msg_chars));
    draw_text_ext(_bx + 16, _by + 30, _shown, 22, _bw - 32);
    draw_set_colour(c_white);
}

if (global.build == BUILD.PLACING && global.build_cost == 0) {
    var _nm = (global.build_obj == obj_pump) ? "Pump" : ((global.build_obj == obj_turret) ? "Turret" : ((global.build_obj == obj_sniper) ? "Sniper" : "Cannon"));
    var _gw = display_get_gui_width();
    draw_set_font(fnt_ui);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_alpha(0.55); draw_set_colour(c_black);
    draw_rectangle(_gw / 2 - 230, 66, _gw / 2 + 230, 96, false);
    draw_set_alpha(1);
    draw_set_colour(COL_GEM);
    draw_text(_gw / 2, 72, "AIRDROP  -  place your free " + _nm + "   (click to drop, ESC to skip)");
    draw_set_colour(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

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
        draw_text(_bx + _bw / 2, _by + _bh / 2 - 20, _def.name);
        draw_text(_bx + _bw / 2, _by + _bh / 2 + 2, type_stats(_def.obj));
        draw_text(_bx + _bw / 2, _by + _bh / 2 + 24, string(_def.cost) + " res");
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
    draw_text(_gw / 2, _py - 26, "UPGRADE  -  time paused");

    var _maxed = bld_level(global.upg_bld) >= BUILD_MAX_LEVEL;
    for (var i = 0; i < _n; i++) {
        var _ry = _py + i * (_rh + _sp);
        var _over = (_mgx > _px && _mgx < _px + _rw && _mgy > _ry && _mgy < _ry + _rh);
        var _afford = (global.resource >= _stats[i].cost);
        draw_set_colour(_maxed ? make_colour_rgb(55, 55, 60) : (_over ? merge_colour(COL_WOOD, c_white, 0.25) : merge_colour(COL_WOOD, c_black, 0.35)));
        draw_rectangle(_px, _ry, _px + _rw, _ry + _rh, false);
        draw_set_colour((_afford || _maxed) ? c_white : make_colour_rgb(210, 120, 120));
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        var _txt = _maxed ? (_stats[i].label + "  " + _stats[i].cur) : (_stats[i].label + "  " + _stats[i].cur + " -> " + _stats[i].nxt);
        draw_text(_px + 14, _ry + _rh / 2, _txt);
        draw_set_halign(fa_right);
        draw_text(_px + _rw - 14, _ry + _rh / 2, _maxed ? "MAX" : string(_stats[i].cost));
    }

    draw_set_colour(c_white);
    draw_set_halign(fa_center);
    draw_text(_gw / 2, _py + _n * (_rh + _sp) + 18, "click a stat to upgrade  -  ESC / click outside to close");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
if (global.build == BUILD.CONVERT && instance_exists(global.upg_bld)) {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    draw_set_alpha(0.6); draw_set_colour(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);
    var _opts = convert_options();
    var _no = array_length(_opts);
    var _bw = 140; var _bh = 90; var _gap = 12;
    var _x0 = _gw / 2 - (_no * _bw + (_no - 1) * _gap) / 2;
    var _by = _gh / 2 - _bh / 2;
    var _mgx = device_mouse_x_to_gui(0);
    var _mgy = device_mouse_y_to_gui(0);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(c_white);
    draw_text(_gw / 2, _by - 34, "CONVERT WALL - time paused   (ESC to cancel)");
    for (var i = 0; i < _no; i++) {
        var _bx = _x0 + i * (_bw + _gap);
        var _over = (_mgx > _bx && _mgx < _bx + _bw && _mgy > _by && _mgy < _by + _bh);
        var _afford = (global.resource >= _opts[i].cost);
        draw_set_colour(_over ? merge_colour(COL_WOOD, c_white, 0.25) : merge_colour(COL_WOOD, c_black, 0.35));
        draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);
        draw_set_colour(_afford ? c_white : make_colour_rgb(210, 120, 120));
        draw_text(_bx + _bw / 2, _by + _bh / 2 - 20, _opts[i].name);
        draw_text(_bx + _bw / 2, _by + _bh / 2 + 2, type_stats(_opts[i].obj));
        draw_text(_bx + _bw / 2, _by + _bh / 2 + 24, string(_opts[i].cost) + " res");
    }
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

if (global.state == GAME_STATE.TITLE) {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    draw_set_alpha(0.6); draw_set_colour(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);
    draw_set_font(fnt_ui);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(COL_SAND);
    draw_text_transformed(_gw / 2, 84, "ISLAND KEEPER", 3, 3, 0);
    draw_set_colour(c_white);

    var _btns = menu_layout(menu_page);

    if (menu_page == MENU.MAIN) {
        draw_set_colour(COL_FOAM);
        draw_text(_gw / 2, 132, "You wash ashore with nothing.");
        draw_set_colour(c_white);
        for (var i = 0; i < array_length(_btns); i++) draw_menu_button(_btns[i], _btns[i].label);

    } else if (menu_page == MENU.HOWTO) {
        var _hx = _gw / 2 - 300;
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_colour(COL_SAND);
        draw_text(_hx, 118, "HOW TO PLAY");
        draw_set_colour(c_white);
        var _lines = [
            "The tide is rising and will drown the island. Survive as long as you can.",
            "",
            "FIGHT:  you auto-attack the nearest enemy in range - strong early, your first weapon.",
            "SALVAGE:  slain enemies drop salvage - your resource to build with.",
            "BUILD (B):  place PUMPS to push back the water, TURRET/SNIPER/CANNON to kill.",
            "MAZE:  buildings are solid - arrange them to funnel the enemies.",
            "PUMPS vs TIDE:  watch the gauge (top-left) - too few pumps and you drown.",
            "UPGRADE:  click a building to boost its stats. Max walls convert to turrets.",
            "AIRDROP:  each wave a plane drops a FREE building - the first one is a pump.",
            "DEFEND:  enemies target your pumps. Lose them and the water wins.",
			"SELL:  right-click a building to sell it back for half its value.",
            "DANGER:  touching an enemy hurts you - with no pump left, they hunt YOU.",
			"MOVE " + key_name(global.key_up) + "/" + key_name(global.key_left) + "/" + key_name(global.key_down) + "/" + key_name(global.key_right) + "    SPACE jump    B build    MOUSE place & aim",
            "",
            "MOVE " + key_name(global.key_up) + "/" + key_name(global.key_left) + "/" + key_name(global.key_down) + "/" + key_name(global.key_right) + "    B build    MOUSE place & aim"
        ];
        for (var i = 0; i < array_length(_lines); i++) draw_text(_hx, 150 + i * 22, _lines[i]);
        draw_menu_button(_btns[0], _btns[0].label);

    } else if (menu_page == MENU.OPTIONS) {
        draw_set_colour(COL_SAND);
        draw_text(_gw / 2, 120, "OPTIONS  -  click a binding, then press a new key");
        draw_set_colour(c_white);
        for (var i = 0; i < array_length(_btns); i++) {
            var _b = _btns[i];
            if (_b.id == "volume") {
                var _sy = _b.y + _b.h / 2;
                draw_set_halign(fa_center);
                draw_set_valign(fa_bottom);
                draw_set_colour(c_white);
                draw_text(_b.x + _b.w / 2, _b.y - 6, "Volume  " + string(round(global.volume * 100)) + "%");
                draw_set_colour(make_colour_rgb(45, 48, 55));
                draw_rectangle(_b.x, _sy - 4, _b.x + _b.w, _sy + 4, false);
                draw_set_colour(COL_FOAM);
                draw_rectangle(_b.x, _sy - 4, _b.x + _b.w * global.volume, _sy + 4, false);
                draw_set_colour(c_white);
                draw_circle(_b.x + _b.w * global.volume, _sy, 7, false);
                draw_set_valign(fa_top);
            } else {
                var _lbl = _b.label;
                if (_b.id == "up")    _lbl = "Move Up  -  "    + (rebind_slot == "up"    ? "< press a key >" : key_name(global.key_up));
                if (_b.id == "down")  _lbl = "Move Down  -  "  + (rebind_slot == "down"  ? "< press a key >" : key_name(global.key_down));
                if (_b.id == "left")  _lbl = "Move Left  -  "  + (rebind_slot == "left"  ? "< press a key >" : key_name(global.key_left));
                if (_b.id == "right") _lbl = "Move Right  -  " + (rebind_slot == "right" ? "< press a key >" : key_name(global.key_right));
                draw_menu_button(_b, _lbl);
            }
        }
    }
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

if (global.state == GAME_STATE.OVER) {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    draw_set_alpha(0.65); draw_set_colour(make_colour_rgb(20, 50, 74));
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(COL_FOAM);
    draw_text_transformed(_gw / 2, _gh / 2 - 55, string_upper(global.lose_reason), 2.5, 2.5, 0);
    draw_set_colour(c_white);
    draw_text(_gw / 2, _gh / 2 + 15, "You held on for " + string(global.wave) + " waves");
    draw_text(_gw / 2, _gh / 2 + 60, "CLICK TO RESTART");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

if (global.paused) {
    var _gw = display_get_gui_width(), _gh = display_get_gui_height();
    draw_set_alpha(0.6); draw_set_colour(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);
    draw_set_font(fnt_ui);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(COL_SAND);
    draw_text_transformed(_gw / 2, _gh / 2 - 110, "PAUSED", 2.5, 2.5, 0);
    draw_set_colour(c_white);

    var _bw = 260, _rx = _gw / 2 - _bw / 2;
    var _vol_y = _gh / 2 - 60, _sfx_y = _gh / 2 - 14, _res_y = _gh / 2 + 40, _exit_y = _gh / 2 + 92;

    draw_set_valign(fa_bottom);
    draw_text(_gw / 2, _vol_y - 4, "Volume  " + string(round(global.volume * 100)) + "%");
    draw_set_valign(fa_middle);
    draw_set_colour(make_colour_rgb(45, 48, 55));
    draw_rectangle(_rx, _vol_y + 4, _rx + _bw, _vol_y + 12, false);
    draw_set_colour(COL_FOAM);
    draw_rectangle(_rx, _vol_y + 4, _rx + _bw * global.volume, _vol_y + 12, false);
    draw_set_colour(c_white);
    draw_circle(_rx + _bw * global.volume, _vol_y + 8, 7, false);

    draw_menu_button({ x: _rx, y: _sfx_y, w: _bw, h: 40 }, "Turret / build SFX:  " + (global.sfx_on ? "ON" : "OFF"));
    draw_menu_button({ x: _rx, y: _res_y, w: _bw, h: 44 }, "RESUME");
    draw_menu_button({ x: _rx, y: _exit_y, w: _bw, h: 44 }, "EXIT TO MENU");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
