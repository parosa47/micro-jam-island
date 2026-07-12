if (global.state == GAME_STATE.TITLE) {
	if (global.audio_ready && !global.menu_music_on) {
        audio_stop_sound(snd_menu);
        audio_play_sound(snd_menu, 10, true, 0.6);
        global.menu_music_on = true;
    }
    if (rebind_slot != "") {
        if (keyboard_check_pressed(vk_anykey)) {
            var _k = keyboard_lastkey;
            if (_k != vk_escape) {
                if (rebind_slot == "up")    global.key_up = _k;
                if (rebind_slot == "down")  global.key_down = _k;
                if (rebind_slot == "left")  global.key_left = _k;
                if (rebind_slot == "right") global.key_right = _k;
            }
            rebind_slot = "";
        }
        exit;
    }
    if (mouse_check_button_pressed(mb_left)) {
		global.audio_ready = true;
        var _btns = menu_layout(menu_page);
        var _mgx = device_mouse_x_to_gui(0);
        var _mgy = device_mouse_y_to_gui(0);
        for (var i = 0; i < array_length(_btns); i++) {
            var _b = _btns[i];
            if (_mgx > _b.x && _mgx < _b.x + _b.w && _mgy > _b.y && _mgy < _b.y + _b.h) {
                switch (_b.id) {
                    case "start":   global.state = GAME_STATE.PLAY; intro_dialogue(); audio_stop_sound(snd_menu); global.menu_music_on = false; break;
                    case "howto":   menu_page = MENU.HOWTO; break;
                    case "options": menu_page = MENU.OPTIONS; break;
                    case "back":    menu_page = MENU.MAIN; break;
		            case "volume":  break;
                    default:        rebind_slot = _b.id; break;
                }
            }
        }
    }
	if (menu_page == MENU.OPTIONS && mouse_check_button(mb_left)) {
        var _mgx = device_mouse_x_to_gui(0);
        var _mgy = device_mouse_y_to_gui(0);
        var _ob = menu_layout(MENU.OPTIONS);
        for (var vi = 0; vi < array_length(_ob); vi++) {
            if (_ob[vi].id == "volume") {
                var _vb = _ob[vi];
                if (_mgx > _vb.x - 6 && _mgx < _vb.x + _vb.w + 6 && _mgy > _vb.y - 10 && _mgy < _vb.y + _vb.h + 10) {
                    global.volume = clamp((_mgx - _vb.x) / _vb.w, 0, 1);
                    audio_master_gain(global.volume);
                }
            }
        }
    }
    exit;
}
if (global.state == GAME_STATE.OVER) {
    if (mouse_check_button_pressed(mb_left)) { global.selling = true; room_restart(); }
    exit;
}
if (global.paused) {
    var _gw = display_get_gui_width(), _gh = display_get_gui_height();
    var _mgx = device_mouse_x_to_gui(0), _mgy = device_mouse_y_to_gui(0);
    var _bw = 260, _rx = _gw / 2 - _bw / 2;
    var _vol_y = _gh / 2 - 60, _sfx_y = _gh / 2 - 14, _res_y = _gh / 2 + 40, _exit_y = _gh / 2 + 92;

    if (keyboard_check_pressed(vk_escape)) { global.paused = false; audio_resume_all(); }

    if (mouse_check_button(mb_left) && _mgx > _rx - 6 && _mgx < _rx + _bw + 6 && _mgy > _vol_y - 10 && _mgy < _vol_y + 22) {
        global.volume = clamp((_mgx - _rx) / _bw, 0, 1);
        audio_master_gain(global.volume);
    }

    if (mouse_check_button_pressed(mb_left) && _mgx > _rx && _mgx < _rx + _bw) {
        if (_mgy > _sfx_y && _mgy < _sfx_y + 40) {
            global.sfx_on = !global.sfx_on;
        } else if (_mgy > _res_y && _mgy < _res_y + 44) {
            global.paused = false;
            audio_resume_all();
        } else if (_mgy > _exit_y && _mgy < _exit_y + 44) {
            global.selling = true;
            audio_stop_all();
            room_restart();
        }
    }
    exit;
}
if (global.shot_snd_t > 0) global.shot_snd_t -= 1;

hover_bld = noone;

if (global.build == BUILD.NONE) {
	if (keyboard_check_pressed(vk_escape)) { global.paused = true; audio_pause_all(); }
    if (keyboard_check_pressed(ord("B"))) global.build = BUILD.MENU;

    var _b = instance_nearest(mouse_x, mouse_y, obj_building);
    if (_b != noone && point_distance(mouse_x, mouse_y, _b.x, _b.y) < 22) hover_bld = _b;

    if (hover_bld != noone && mouse_check_button_pressed(mb_left)) {
        global.upg_bld = hover_bld;
        global.build = (hover_bld.kind == "wall") ? BUILD.CONVERT : BUILD.UPGRADE;
    }

    if (hover_bld != noone && mouse_check_button_pressed(mb_right)) {
        var _inv = variable_instance_exists(hover_bld, "invested") ? hover_bld.invested : hover_bld.base_cost;
        var _refund = round(_inv * SELL_REFUND);
        global.resource += _refund;
        float_text(hover_bld.x, hover_bld.y - 14, "+" + string(_refund), COL_GEM);
        spawn_particles(hover_bld.x, hover_bld.y, COL_METAL, 8);
        audio_play_sound(snd_place, 4, false, 1, 0, 0.7);
        if (hover_bld.kind == "offensive" || hover_bld.kind == "wall") global.nav_dirty = true;
        global.selling = true;
        with (hover_bld) instance_destroy();
        global.selling = false;
        hover_bld = noone;
    }
} else if (global.build == BUILD.UPGRADE) {
    if (!instance_exists(global.upg_bld) || keyboard_check_pressed(vk_escape)) {
        global.build = BUILD.NONE;
    } else if (mouse_check_button_pressed(mb_left)) {
        var _gw = display_get_gui_width();
        var _gh = display_get_gui_height();
        var _stats = upg_stats(global.upg_bld);
        var _n = array_length(_stats);
        var _rw = 320; var _rh = 34; var _sp = 8;
        var _px = _gw / 2 - _rw / 2;
        var _py = _gh / 2 - (_n * (_rh + _sp)) / 2;
        var _mgx = device_mouse_x_to_gui(0);
        var _mgy = device_mouse_y_to_gui(0);
        var _hit = false;
        for (var i = 0; i < _n; i++) {
            var _ry = _py + i * (_rh + _sp);
            if (_mgx > _px && _mgx < _px + _rw && _mgy > _ry && _mgy < _ry + _rh) {
                upg_apply(global.upg_bld, _stats[i].id);
                _hit = true;
            }
        }
        if (!_hit) global.build = BUILD.NONE;
    }
} else if (global.build == BUILD.CONVERT) {
    if (!instance_exists(global.upg_bld) || keyboard_check_pressed(vk_escape)) {
        global.build = BUILD.NONE;
    } else if (mouse_check_button_pressed(mb_left)) {
        var _gw = display_get_gui_width();
        var _gh = display_get_gui_height();
        var _opts = convert_options();
        var _no = array_length(_opts);
        var _bw = 140; var _bh = 90; var _gap = 12;
        var _x0 = _gw / 2 - (_no * _bw + (_no - 1) * _gap) / 2;
        var _by = _gh / 2 - _bh / 2;
        var _mgx = device_mouse_x_to_gui(0);
        var _mgy = device_mouse_y_to_gui(0);
        var _hit = false;
        for (var i = 0; i < _no; i++) {
            var _bx = _x0 + i * (_bw + _gap);
            if (_mgx > _bx && _mgx < _bx + _bw && _mgy > _by && _mgy < _by + _bh) {
                _hit = true;
                if (global.resource >= _opts[i].cost) {
                    var _wx = global.upg_bld.x;
                    var _wy = global.upg_bld.y;
                    var _inv = global.upg_bld.invested + _opts[i].cost;
                    with (global.upg_bld) instance_destroy();
                    var _new = instance_create_layer(_wx, _wy, "Instances", _opts[i].obj);
                    _new.invested = _inv;
                    global.resource -= _opts[i].cost;
                    global.nav_dirty = true;
                    global.build = BUILD.NONE;
                }
            }
        }
        if (!_hit) global.build = BUILD.NONE;
    }
} else if (global.build == BUILD.MENU) {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    var _n = array_length(global.build_defs);
    var _bw = 140; var _bh = 90; var _gap = 12;
    var _total = _n * _bw + (_n - 1) * _gap;
    var _x0 = _gw / 2 - _total / 2;
    var _by = _gh / 2 - _bh / 2;
    var _mgx = device_mouse_x_to_gui(0);
    var _mgy = device_mouse_y_to_gui(0);
    if (mouse_check_button_pressed(mb_left)) {
        for (var i = 0; i < _n; i++) {
            var _bx = _x0 + i * (_bw + _gap);
            if (_mgx > _bx && _mgx < _bx + _bw && _mgy > _by && _mgy < _by + _bh) {
                global.build_obj = global.build_defs[i].obj;
                global.build_cost = global.build_defs[i].cost;
                global.build = BUILD.PLACING;
            }
        }
    }
    if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("B"))) global.build = BUILD.NONE;
} else {
    var _cx = grid_snap(mouse_x);
    var _cy = grid_snap(mouse_y);
    var _ex = island_r * (1 - global.water_level);
    var _nb = instance_nearest(_cx, _cy, obj_building);
    var _clear = (_nb == noone) || (point_distance(_cx, _cy, _nb.x, _nb.y) > CELL * 0.5);
    var _on_land = point_distance(island_x, island_y, _cx, _cy) < _ex - 14;
    var _afford = (global.resource >= global.build_cost);

    var _blocks = false;
    if (_clear && _on_land && _afford) {
        if (is_solid_type(global.build_obj)) {
            var _cxx = floor(_cx / CELL);
            var _cyy = floor(_cy / CELL);
            mp_grid_add_cell(global.nav, _cxx, _cyy);
            with (obj_pump) {
                if (!mp_grid_path(global.nav, global.testpath, x, y, CELL * 0.5, CELL * 0.5, true)) _blocks = true;
            }
            mp_grid_clear_cell(global.nav, _cxx, _cyy);
        } else if (global.build_obj == obj_pump) {
            if (!mp_grid_path(global.nav, global.testpath, _cx, _cy, CELL * 0.5, CELL * 0.5, true)) _blocks = true;
        }
    }

    global.build_valid = _clear && _on_land && _afford && !_blocks;
    if (mouse_check_button_pressed(mb_left) && global.build_valid) {
        global.resource -= global.build_cost;
        var _new = instance_create_layer(_cx, _cy, "Instances", global.build_obj);
        _new.invested = global.build_cost;
        if (global.sfx_on) audio_play_sound(snd_place, 6, false);
        global.nav_dirty = true;
        global.build = BUILD.NONE;
    }
    if (mouse_check_button_pressed(mb_right) || keyboard_check_pressed(vk_escape)) global.build = BUILD.NONE;
}

if (global.nav_dirty) {
    mp_grid_clear_all(global.nav);
    with (obj_building) {
        if (kind == "offensive" || kind == "wall") mp_grid_add_cell(global.nav, floor(x / CELL), floor(y / CELL));
    }
    global.nav_version += 1;
    global.nav_dirty = false;
}

if (array_length(global.msg_queue) > 0) {
    var _m = global.msg_queue[0];
    var _len = string_length(_m.txt);

    if (!global.msg_voiced) {
        global.msg_voiced = true;
        if (_m.spk == "RADIO") {
            global.radio_voice = audio_play_sound(snd_radio, 5, true, 1, random(30), random_range(0.9, 1.1));
        }
    }

    if (global.msg_chars < _len) {
        global.msg_chars += TEXT_SPEED;
        if (global.msg_chars >= _len && global.radio_voice != -1) {
            audio_stop_sound(global.radio_voice);
            global.radio_voice = -1;
        }
    }

    global.msg_t += 1;
    if (global.msg_chars >= _len && global.msg_t >= _m.dur) {
        array_delete(global.msg_queue, 0, 1);
        global.msg_t = 0;
        global.msg_chars = 0;
        global.msg_voiced = false;
    }
}

if (is_frozen()) exit;

if (global.grace_t > 0) {
    global.grace_t -= 1;
} else if (global.wave >= 3) {
    var _net = wave_rise_rate(global.wave) - global.pump_capacity;
    global.water_level += _net / GAME_FPS;
    global.water_level = clamp(global.water_level, 0, 1);
    if (global.water_level >= WATER_LOSE) {
        global.lose_reason = "The island drowned";
        global.state = GAME_STATE.OVER;
        if (global.radio_voice != -1) { audio_stop_sound(global.radio_voice); global.radio_voice = -1; }
    }
}

if (global.grace_t <= 0) {
    if (wave_to_spawn > 0) {
    enemy_timer -= 1;
    if (enemy_timer <= 0) {
        enemy_timer = ENEMY_SPAWN_CD;
        var _a = random(360);
        var _sx = island_x + lengthdir_x(island_r + 80, _a);
        var _sy = island_y + lengthdir_y(island_r + 80, _a);
        if (boss_pending) {
            spawn_enemy(_sx, _sy, 3);
            boss_pending = false;
        } else {
            spawn_enemy(_sx, _sy, pick_enemy_type(global.wave));
        }
        wave_to_spawn -= 1;
    }
} else if (instance_number(obj_enemy) == 0) {
    intermission_t -= 1;
    if (intermission_t <= 0) {
        global.wave += 1;
        wave_to_spawn = wave_enemy_count(global.wave);
        if (global.wave mod 5 == 0) boss_pending = true;
        intermission_t = WAVE_PAUSE * GAME_FPS;
    }
}
}

if (global.grace_t <= 0 && global.wave != plane_wave) {
    plane_wave = global.wave;
    radio_message(global.wave);
    if (global.wave >= 2 && (global.wave - 2) mod 3 == 0) {
        instance_create_layer(-80, island_y - 120, "Instances", obj_plane);
    }
}