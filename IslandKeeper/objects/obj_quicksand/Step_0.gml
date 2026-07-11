if (global.state != GAME_STATE.PLAY) exit;
if (is_frozen()) exit;
var _ex = obj_game.island_r * (1 - global.water_level);
if (point_distance(obj_game.island_x, obj_game.island_y, x, y) > _ex) { instance_destroy(); exit; }

var _range = base_range + (range_lvl - 1) * 30;
var _slow = max(0.2, QUICKSAND_SLOW - (slow_lvl - 1) * 0.08);
with (obj_enemy) {
    if (point_distance(x, y, other.x, other.y) < _range) {
        slow_t = 5;
        slow_mult = min(slow_mult, _slow);
    }
}