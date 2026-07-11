game_set_speed(GAME_FPS, gamespeed_fps);
draw_set_circle_precision(64);
depth = 1000;

global.state = GAME_STATE.TITLE;
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
global.upg_bld = noone;
global.nav = mp_grid_create(0, 0, ceil(room_width / CELL), ceil(room_height / CELL), CELL, CELL);
global.nav_dirty = true;
global.nav_version = 0;
global.testpath = path_add();


island_x = room_width / 2;
island_y = room_height / 2;
island_r = 520;
hover_bld = noone;

enemy_timer = 0;
wave_to_spawn = wave_enemy_count(global.wave);
intermission_t = WAVE_PAUSE * GAME_FPS;

global.build_defs = [
    { obj: obj_pump,      name: "Pump",      cost: PUMP_COST },
	{ obj: obj_wall,      name: "Wall",      cost: WALL_COST },
    { obj: obj_turret,    name: "Turret",    cost: TURRET_COST },
    { obj: obj_sniper,    name: "Sniper",    cost: SNIPER_COST },
    { obj: obj_cannon,    name: "Cannon",    cost: CANNON_COST },
    { obj: obj_quicksand, name: "Quicksand", cost: QUICKSAND_COST }
];

global.enemy_defs = [
    { hp: 1.0,  spd: 1.0, rad: 9,  col: COL_ENEMY,                    boss: false, drop: 1 },
    { hp: 0.5,  spd: 1.9, rad: 7,  col: make_colour_rgb(235, 205, 90), boss: false, drop: 1 },
    { hp: 2.6,  spd: 0.6, rad: 13, col: make_colour_rgb(150, 90, 180), boss: false, drop: 2 },
    { hp: 14.0, spd: 0.5, rad: 22, col: make_colour_rgb(150, 40, 60),  boss: true,  drop: 12 }
];
boss_pending = false;

repeat (CACHE_COUNT) {
    var _a = random(360);
    var _d = random_range(60, island_r - 60);
    instance_create_layer(island_x + lengthdir_x(_d, _a), island_y + lengthdir_y(_d, _a), "Instances", obj_cache);
}