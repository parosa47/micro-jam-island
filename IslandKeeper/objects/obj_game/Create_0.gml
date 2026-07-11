game_set_speed(GAME_FPS, gamespeed_fps);
draw_set_circle_precision(64);
depth = 1000;

global.state = GAME_STATE.PLAY;
global.water_level = 0;
global.pump_capacity = 0;
global.resource = START_RESOURCE;
global.wave = 1;
global.score = 0;
global.grace_t = GRACE_SECONDS * GAME_FPS;
global.build = BUILD.NONE;
global.build_obj = noone;
global.build_cost = 0;
global.build_valid = false;

island_x = room_width / 2;
island_y = room_height / 2;
island_r = 520;
hover_bld = noone;

enemy_timer = 0;
wave_to_spawn = wave_enemy_count(global.wave);
intermission_t = WAVE_PAUSE * GAME_FPS;

repeat (CACHE_COUNT) {
    var _a = random(360);
    var _d = random_range(60, island_r - 60);
    instance_create_layer(island_x + lengthdir_x(_d, _a), island_y + lengthdir_y(_d, _a), "Instances", obj_cache);
}