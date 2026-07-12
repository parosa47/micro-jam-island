if (global.state != GAME_STATE.PLAY) exit;
var _ex = obj_game.island_r * (1 - global.water_level);
if (point_distance(obj_game.island_x, obj_game.island_y, x, y) > _ex) { instance_destroy(); exit; }
if (instance_exists(obj_player) && point_distance(x, y, obj_player.x, obj_player.y) < 18) {
    global.resource += value;
	float_text(x, y - 10, "+" + string(value), COL_GEM);
	audio_play_sound(snd_pickup, 3, false, 1, 0, random_range(0.95, 1.1));
    instance_destroy();
}