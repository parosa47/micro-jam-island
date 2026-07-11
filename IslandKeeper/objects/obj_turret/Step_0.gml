if (global.state != GAME_STATE.PLAY) exit;
if (is_frozen()) exit;

var _ex = obj_game.island_r * (1 - global.water_level);
if (point_distance(obj_game.island_x, obj_game.island_y, x, y) > _ex) { instance_destroy(); exit; }

var _range = TURRET_RANGE + (range_lvl - 1) * 30;
fire_cd -= 1;
if (fire_cd <= 0) {
    var _e = instance_nearest(x, y, obj_enemy);
    if (_e != noone && point_distance(x, y, _e.x, _e.y) < _range) {
        fire_cd = max(8, TURRET_FIRE_CD - (rate_lvl - 1) * 4);
        var _b = instance_create_layer(x, y, "Instances", obj_projectile);
        _b.target = _e;
        _b.dmg = TURRET_DMG * dmg_lvl;
        audio_play_sound(snd_shoot, 5, false, 1, 0, random_range(0.92, 1.08));
    }
}
offensive_step();