if (global.state != GAME_STATE.PLAY) exit;
if (global.build == BUILD.MENU) exit;
if (!instance_exists(target)) { instance_destroy(); exit; }
var _dir = point_direction(x, y, target.x, target.y);
x += lengthdir_x(spd, _dir);
y += lengthdir_y(spd, _dir);
if (point_distance(x, y, target.x, target.y) < 10) {
    target.hp -= dmg;
	target.flash = 3;
    instance_destroy();
}