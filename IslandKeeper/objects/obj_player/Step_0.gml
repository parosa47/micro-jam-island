if (global.state != GAME_STATE.PLAY) exit;

var _mx = keyboard_check(vk_right) - keyboard_check(vk_left);
var _my = keyboard_check(vk_down) - keyboard_check(vk_up);

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
        with (_c) instance_destroy();
    }
}