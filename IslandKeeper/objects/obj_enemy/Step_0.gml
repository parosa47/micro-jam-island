if (global.state != GAME_STATE.PLAY) exit;

if (!instance_exists(target)) target = instance_nearest(x, y, obj_pump);
var _tx = (target != noone) ? target.x : obj_game.island_x;
var _ty = (target != noone) ? target.y : obj_game.island_y;

var _dir = point_direction(x, y, _tx, _ty);
x += lengthdir_x(ENEMY_SPEED, _dir);
y += lengthdir_y(ENEMY_SPEED, _dir);

if (target != noone && point_distance(x, y, target.x, target.y) < 20) {
    target.hp -= ENEMY_CONTACT_DMG;
    if (target.hp <= 0) with (target) instance_destroy();
}

if (hp <= 0) {
    instance_create_layer(x, y, "Instances", obj_pickup);
    instance_destroy();
}