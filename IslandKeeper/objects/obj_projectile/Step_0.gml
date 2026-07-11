if (global.state != GAME_STATE.PLAY) exit;
if (is_frozen()) exit;
if (!instance_exists(target)) { instance_destroy(); exit; }
var _dir = point_direction(x, y, target.x, target.y);
x += lengthdir_x(spd, _dir);
y += lengthdir_y(spd, _dir);
if (point_distance(x, y, target.x, target.y) < 10) {
    if (aoe > 0) {
        with (obj_enemy) {
            if (point_distance(x, y, other.x, other.y) < other.aoe) { hp -= other.dmg; flash = 3; }
        }
        spawn_particles(x, y, c_white, 6);
    } else {
        target.hp -= dmg;
        target.flash = 3;
    }
    audio_play_sound(snd_hit, 4, false, 1, 0, random_range(0.9, 1.1));
    instance_destroy();
}