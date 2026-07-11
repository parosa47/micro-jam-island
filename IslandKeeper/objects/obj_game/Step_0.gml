if (global.state != GAME_STATE.PLAY) exit;
hover_bld = noone;

if (global.build == BUILD.NONE) {
    if (keyboard_check_pressed(ord("B"))) global.build = BUILD.MENU;

    var _bp = instance_nearest(mouse_x, mouse_y, obj_pump);
    var _bt = instance_nearest(mouse_x, mouse_y, obj_turret);
    var _bd = 22;
    if (_bp != noone && point_distance(mouse_x, mouse_y, _bp.x, _bp.y) < _bd) { hover_bld = _bp; _bd = point_distance(mouse_x, mouse_y, _bp.x, _bp.y); }
    if (_bt != noone && point_distance(mouse_x, mouse_y, _bt.x, _bt.y) < _bd) { hover_bld = _bt; }

    if (hover_bld != noone) {
        if (hover_bld.object_index == obj_pump) {
            if (mouse_check_button_pressed(mb_left)) upgrade_pump(hover_bld);
        } else {
            if (mouse_check_button_pressed(mb_left)) upgrade_turret_stat(hover_bld, true);
            if (mouse_check_button_pressed(mb_right)) upgrade_turret_stat(hover_bld, false);
        }
    }
} else if (global.build == BUILD.MENU) {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    var _bw = 200; var _bh = 90; var _gap = 40;
    var _by = _gh / 2 - _bh / 2;
    var _bx1 = _gw / 2 - _bw - _gap / 2;
    var _bx2 = _gw / 2 + _gap / 2;
    var _mgx = device_mouse_x_to_gui(0);
    var _mgy = device_mouse_y_to_gui(0);
    var _over1 = (_mgx > _bx1 && _mgx < _bx1 + _bw && _mgy > _by && _mgy < _by + _bh);
    var _over2 = (_mgx > _bx2 && _mgx < _bx2 + _bw && _mgy > _by && _mgy < _by + _bh);
    if (mouse_check_button_pressed(mb_left)) {
        if (_over1)      { global.build_obj = obj_pump;   global.build_cost = PUMP_COST;   global.build = BUILD.PLACING; }
        else if (_over2) { global.build_obj = obj_turret; global.build_cost = TURRET_COST; global.build = BUILD.PLACING; }
    }
    if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("B"))) global.build = BUILD.NONE;
} else {
    var _cx = mouse_x;
    var _cy = mouse_y;
    var _ex = island_r * (1 - global.water_level);
    var _np = instance_nearest(_cx, _cy, obj_pump);
    var _nt = instance_nearest(_cx, _cy, obj_turret);
    var _clear = ((_np == noone) || point_distance(_cx, _cy, _np.x, _np.y) > 28) && ((_nt == noone) || point_distance(_cx, _cy, _nt.x, _nt.y) > 28);
    global.build_valid = (point_distance(island_x, island_y, _cx, _cy) < _ex - 14) && (global.resource >= global.build_cost) && _clear;
    if (mouse_check_button_pressed(mb_left) && global.build_valid) {
        global.resource -= global.build_cost;
        instance_create_layer(_cx, _cy, "Instances", global.build_obj);
		audio_play_sound(snd_place, 6, false);
        global.build = BUILD.NONE;
    }
    if (mouse_check_button_pressed(mb_right) || keyboard_check_pressed(vk_escape)) global.build = BUILD.NONE;
}

if (global.build == BUILD.MENU) exit;

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