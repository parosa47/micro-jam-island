if (global.state != GAME_STATE.PLAY) exit;
var _ex = obj_game.island_r * (1 - global.water_level);
if (point_distance(obj_game.island_x, obj_game.island_y, x, y) > _ex) { instance_destroy(); exit; }
if (instance_exists(obj_player) && point_distance(x, y, obj_player.x, obj_player.y) < 18) {
    global.resource += PICKUP_VALUE;
    instance_destroy();
}