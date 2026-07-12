if (global.state != GAME_STATE.PLAY) exit;
if (is_frozen()) exit;

if (slow_t > 0) slow_t -= 1; else slow_mult = 1;
var _spd = ENEMY_SPEED * spd_mult * slow_mult;

if (!instance_exists(target)) {
    var _p = instance_nearest(x, y, obj_pump);
    target = (_p != noone) ? _p : instance_nearest(x, y, obj_player);
    path_version = -1;
}

if (target != noone && target.object_index == obj_player) {
    var _pp = instance_nearest(x, y, obj_pump);
    if (_pp != noone) { target = _pp; path_version = -1; }
    else {
        repath_t -= 1;
        if (repath_t <= 0) { path_version = -1; repath_t = 20; }
    }
}

if (path_version != global.nav_version && target != noone) {
    if (mp_grid_path(global.nav, path, x, y, target.x, target.y, true)) {
        path_version = global.nav_version;
        wp = 1;
    } else {
        path_version = -2;
    }
}

var _tx, _ty;
if (path_version >= 0 && path_get_number(path) >= 2) {
    var _n = path_get_number(path);
    _tx = path_get_point_x(path, wp);
    _ty = path_get_point_y(path, wp);
    if (point_distance(x, y, _tx, _ty) < 6 && wp < _n - 1) {
        wp += 1;
        _tx = path_get_point_x(path, wp);
        _ty = path_get_point_y(path, wp);
    }
} else if (target != noone) {
    _tx = target.x; _ty = target.y;
} else {
    _tx = obj_game.island_x; _ty = obj_game.island_y;
}

var _dist = point_distance(x, y, _tx, _ty);
if (_dist > 2) {
    var _dir = point_direction(x, y, _tx, _ty);
	face = _dir;
    x += lengthdir_x(min(_spd, _dist), _dir);
    y += lengthdir_y(min(_spd, _dist), _dir);
}

if (target != noone && target.object_index != obj_player && point_distance(x, y, target.x, target.y) < 20) {
    target.hp -= ENEMY_CONTACT_DMG;
    if (target.hp <= 0) with (target) instance_destroy();
}

if (hp <= 0) {
    spawn_particles(x, y, col, is_boss ? 20 : 8);
    add_shake(is_boss ? 8 : 3);
    audio_play_sound(snd_enemy_die, 6, false, 1, 0, random_range(0.92, 1.08));
    repeat (drop) {
        var _pk = instance_create_layer(x, y, "Instances", obj_pickup);
        _pk.value = pickup_value(global.wave);
    }
    instance_destroy();
}