if (global.state != GAME_STATE.PLAY) exit;

hover_bld = noone;

if (global.build == BUILD.NONE) {
    if (keyboard_check_pressed(ord("B"))) global.build = BUILD.MENU;

    var _b = instance_nearest(mouse_x, mouse_y, obj_building);
    if (_b != noone && point_distance(mouse_x, mouse_y, _b.x, _b.y) < 22) hover_bld = _b;

    if (hover_bld != noone && mouse_check_button_pressed(mb_left)) {
        global.upg_bld = hover_bld;
        global.build = (hover_bld.kind == "wall") ? BUILD.CONVERT : BUILD.UPGRADE;
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
                    with (global.upg_bld) instance_destroy();
                    instance_create_layer(_wx, _wy, "Instances", _opts[i].obj);
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
    if (_clear && _on_land && _afford && is_solid_type(global.build_obj)) {
        var _cxx = floor(_cx / CELL);
        var _cyy = floor(_cy / CELL);
        mp_grid_add_cell(global.nav, _cxx, _cyy);
        with (obj_pump) {
            if (!mp_grid_path(global.nav, global.testpath, x, y, CELL * 0.5, CELL * 0.5, true)) _blocks = true;
        }
        mp_grid_clear_cell(global.nav, _cxx, _cyy);
    }

    global.build_valid = _clear && _on_land && _afford && !_blocks;
    if (mouse_check_button_pressed(mb_left) && global.build_valid) {
        global.resource -= global.build_cost;
        instance_create_layer(_cx, _cy, "Instances", global.build_obj);
        audio_play_sound(snd_place, 6, false);
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

if (is_frozen()) exit;

if (global.grace_t > 0) {
    global.grace_t -= 1;
} else {
    var _net = wave_rise_rate(global.wave) - global.pump_capacity;
    global.water_level += _net / GAME_FPS;
    global.water_level = clamp(global.water_level, 0, 1);
    if (global.water_level >= WATER_LOSE) global.state = GAME_STATE.OVER;
}

if (global.grace_t <= 0) {
    if (wave_to_spawn > 0) {
        enemy_timer -= 1;
        if (enemy_timer <= 0) {
            enemy_timer = ENEMY_SPAWN_CD;
            var _a = random(360);
            instance_create_layer(island_x + lengthdir_x(island_r + 80, _a), island_y + lengthdir_y(island_r + 80, _a), "Instances", obj_enemy);
            wave_to_spawn -= 1;
        }
    } else if (instance_number(obj_enemy) == 0) {
        intermission_t -= 1;
        if (intermission_t <= 0) {
            global.wave += 1;
            wave_to_spawn = wave_enemy_count(global.wave);
            intermission_t = WAVE_PAUSE * GAME_FPS;
        }
    }
}