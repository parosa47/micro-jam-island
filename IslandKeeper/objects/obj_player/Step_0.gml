if (global.state != GAME_STATE.PLAY) exit;
if (is_frozen()) exit;

var _mx = keyboard_check(global.key_right) - keyboard_check(global.key_left);
var _my = keyboard_check(global.key_down) - keyboard_check(global.key_up);
var _exposed = obj_game.island_r * (1 - global.water_level);

moving = (_mx != 0 || _my != 0);
if (moving) {
    var _dir = point_direction(0, 0, _mx, _my);
    facing = _dir;
    var _vx = lengthdir_x(move_speed, _dir);
    var _vy = lengthdir_y(move_speed, _dir);
    if (jump_z > 0 || player_blocked(x, y)) {
        x += _vx;
        y += _vy;
    } else {
        if (!player_blocked(x + _vx, y)) x += _vx;
        if (!player_blocked(x, y + _vy)) y += _vy;
    }
    anim += 0.28;
    if (_mx > 0) face_x = 1; else if (_mx < 0) face_x = -1;
} else {
    anim += 0.05;
}

if (jump_z <= 0 && keyboard_check_pressed(vk_space)) {
    jump_vz = JUMP_POWER;
    jump_z = 0.01;
    audio_play_sound(snd_jump, 4, false, 1, 0, 1.4);
}
if (jump_z > 0) {
    jump_z += jump_vz;
    jump_vz -= JUMP_GRAVITY;
    if (jump_z <= 0) { jump_z = 0; jump_vz = 0; }
}

if (point_distance(obj_game.island_x, obj_game.island_y, x, y) > _exposed - 10) {
    var _bdir = point_direction(obj_game.island_x, obj_game.island_y, x, y);
    x = obj_game.island_x + lengthdir_x(_exposed - 10, _bdir);
    y = obj_game.island_y + lengthdir_y(_exposed - 10, _bdir);
}

aa_timer -= 1;
if (aa_timer <= 0) {
    var _e = instance_nearest(x, y, obj_enemy);
    if (_e != noone && point_distance(x, y, _e.x, _e.y) < PLAYER_AA_RANGE) {
        aa_timer = GAME_FPS;
        aa_target = _e;
        aa_show = 6;
        var _dmg = _e.is_boss ? (_e.hp_max * AA_DMG_BOSS) : (_e.hp_max * AA_DMG_NORMAL + AA_DMG_FLAT);
        _e.hp -= _dmg;
		audio_play_sound(snd_hit, 4, false, 1, 0, random_range(0.9, 1.1));
		_e.flash = 3;
    }
}

if (hurt_t > 0) hurt_t -= 1;
if (hurt_flash > 0) hurt_flash -= 1;
if (hurt_t <= 0 && jump_z <= 0) {
    var _e = instance_nearest(x, y, obj_enemy);
    if (_e != noone && point_distance(x, y, _e.x, _e.y) < _e.rad + 12) {
        hp -= PLAYER_HURT;
        hurt_t = PLAYER_IFRAMES;
        hurt_flash = 8;
        add_shake(4);
        audio_play_sound(snd_hit, 5, false, 1, 0, 0.7);
        if (hp <= 0) {
            global.lose_reason = "You were overrun";
            global.state = GAME_STATE.OVER;
            if (global.radio_voice != -1) { audio_stop_sound(global.radio_voice); global.radio_voice = -1; }
        }
    }
}