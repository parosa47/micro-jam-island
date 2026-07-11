if (global.state != GAME_STATE.PLAY) exit;
if (global.build == BUILD.MENU) exit;

if (!instance_exists(target)) target = instance_nearest(x, y, obj_pump);
var _tx = (target != noone) ? target.x : obj_game.island_x;
var _ty = (target != noone) ? target.y : obj_game.island_y;

var _dist = point_distance(x, y, _tx, _ty);
if (_dist > 4) {
    var _dir = point_direction(x, y, _tx, _ty);
    x += lengthdir_x(min(ENEMY_SPEED, _dist), _dir);
    y += lengthdir_y(min(ENEMY_SPEED, _dist), _dir);
}

if (target != noone && point_distance(x, y, target.x, target.y) < 20) {
    target.hp -= ENEMY_CONTACT_DMG;
    if (target.hp <= 0) with (target) instance_destroy();
}

if (hp <= 0) {
    spawn_particles(x, y, COL_ENEMY, 8);
    add_shake(3);
	audio_play_sound(snd_enemy_die, 6, false, 1, 0, random_range(0.92, 1.08));
    repeat (1 + floor(global.wave / 2)) instance_create_layer(x, y, "Instances", obj_pickup);
    instance_destroy();
}