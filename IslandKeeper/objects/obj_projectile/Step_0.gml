if (global.state != GAME_STATE.PLAY) exit;
if (global.build == BUILD.MENU) exit;
if (!instance_exists(target)) { instance_destroy(); exit; }
var _dir = point_direction(x, y, target.x, target.y);
x += lengthdir_x(spd, _dir);
y += lengthdir_y(spd, _dir);
if (point_distance(x, y, target.x, target.y) < 10) {
    target.hp -= dmg;
	audio_play_sound(snd_hit, 4, false, 1, 0, random_range(0.9, 1.1));
	target.flash = 3;
    instance_destroy();
}