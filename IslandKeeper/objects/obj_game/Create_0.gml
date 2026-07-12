game_set_speed(GAME_FPS, gamespeed_fps);
draw_set_circle_precision(64);
depth = 1000;
plane_wave = 0;

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
global.msg_queue = [];
global.msg_t = 0;
global.msg_chars = 0;
global.msg_voiced = false;
global.radio_voice = -1;
global.shot_snd_t = 0;
global.first_cargo = true;
global.selling = false;
global.lose_reason = "The island drowned";
global.menu_music_on = false;
global.paused = false;
if (!variable_global_exists("audio_ready")) global.audio_ready = false;
if (os_browser == browser_not_a_browser) global.audio_ready = true;


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

menu_page = MENU.MAIN;
rebind_slot = "";
if (!variable_global_exists("key_up")) {
    global.key_up = ord("Z");
    global.key_down = ord("S");
    global.key_left = ord("Q");
    global.key_right = ord("D");
}

island_n = 64;
island_coast = array_create(island_n);
island_veg = array_create(island_n);
var _p1 = random(360), _p2 = random(360), _p3 = random(360);
var _q1 = random(360), _q2 = random(360);
for (var _i = 0; _i < island_n; _i++) {
    var _ia = _i / island_n * 360;
    island_coast[_i] = 1 + 0.05 * dsin(_ia * 3 + _p1) + 0.035 * dsin(_ia * 5 + _p2) + 0.02 * dsin(_ia * 7 + _p3);
    island_veg[_i]   = 1 + 0.12 * dsin(_ia * 2 + _q1) + 0.07 * dsin(_ia * 4 + _q2);
}
island_deco = array_create(7);
for (var _i = 0; _i < 7; _i++) {
    island_deco[_i] = { a: random(360), dist: random_range(0.12, 0.46) * island_r, s: random_range(16, 30), palm: (_i < 3) };
}

if (!variable_global_exists("volume")) global.volume = 1;
if (!variable_global_exists("tut_on")) global.tut_on = true;
if (!variable_global_exists("sfx_on")) global.sfx_on = true;
audio_master_gain(global.volume);
global.tut = 0;
if (!variable_global_exists("tut_seen")) global.tut_seen = false;