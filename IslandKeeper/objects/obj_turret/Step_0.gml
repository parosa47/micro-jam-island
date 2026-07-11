if (global.state != GAME_STATE.PLAY) exit;
if (global.build == BUILD.MENU) exit;

var _ex = obj_game.island_r * (1 - global.water_level);
if (point_distance(obj_game.island_x, obj_game.island_y, x, y) > _ex) { instance_destroy(); exit; }

fire_cd -= 1;
if (fire_cd <= 0) {
    var _e = instance_nearest(x, y, obj_enemy);
    if (_e != noone && point_distance(x, y, _e.x, _e.y) < TURRET_RANGE) {
        fire_cd = TURRET_FIRE_CD;
        var _b = instance_create_layer(x, y, "Instances", obj_projectile);
        _b.target = _e;
        _b.dmg = TURRET_DMG;
    }
}