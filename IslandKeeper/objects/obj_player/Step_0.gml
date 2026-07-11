if (global.state != GAME_STATE.PLAY) exit;
if (global.build == BUILD.MENU) exit;

var _mx = keyboard_check(ord("D")) - keyboard_check(ord("Q"));
var _my = keyboard_check(ord("S")) - keyboard_check(ord("Z"));
var _exposed = obj_game.island_r * (1 - global.water_level);

if (_mx != 0 || _my != 0) {
    var _dir = point_direction(0, 0, _mx, _my);
    facing = _dir;
    x += lengthdir_x(move_speed, _dir);
    y += lengthdir_y(move_speed, _dir);
}

if (keyboard_check_pressed(vk_space)) {
    var _c = instance_nearest(x, y, obj_cache);
    if (_c != noone && point_distance(x, y, _c.x, _c.y) < DIG_RANGE) {
        global.resource += CACHE_RESOURCE;
		audio_play_sound(snd_dig, 4, false);
        with (_c) instance_destroy();
    }
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
        var _mult = _e.is_boss ? AA_DMG_BOSS : AA_DMG_NORMAL;
        _e.hp -= _e.hp_max * _mult;
		audio_play_sound(snd_hit, 4, false, 1, 0, random_range(0.9, 1.1));
		_e.flash = 3;
    }
}