#macro GAME_FPS 60

#macro WATER_BASE_RISE 0
#macro WATER_RISE_GROWTH 0.30
#macro WATER_LOSE 0.9
#macro WATER_RISE_STEP 0.02

#macro PLAYER_HP 100
#macro PLAYER_HURT 10
#macro PLAYER_IFRAMES 45

#macro START_RESOURCE 0
#macro GRACE_SECONDS 10

#macro PUMP_HP 60
#macro PUMP_COST 15
#macro PUMP_FLOW 0.02
#macro PUMP_FLOW_GROWTH 0.5
#macro OFF_DMG_GROWTH 0.4

#macro TURRET_HP 45
#macro TURRET_COST 20
#macro TURRET_RANGE 110
#macro TURRET_FIRE_CD 90
#macro TURRET_DMG 16
#macro BUILD_MAX_LEVEL 8
#macro UPGRADE_COST_MULT 0.75

#macro ENEMY_HP_BASE 30
#macro ENEMY_HP_GROWTH 0.234
#macro PLAYER_AA_RANGE 130
#macro JUMP_POWER 4.2
#macro JUMP_GRAVITY 0.28

#macro CACHE_COUNT 6
#macro CACHE_RESOURCE 10
#macro DIG_RANGE 28

#macro ENEMY_SPAWN_CD 90
#macro ENEMY_SPEED 1.1
#macro ENEMY_CONTACT_DMG 0.5
#macro PICKUP_VALUE 5

#macro WAVE_PAUSE 6
#macro AA_DMG_NORMAL 0.12
#macro AA_DMG_BOSS 0.02
#macro AA_DMG_FLAT 12

#macro SNIPER_COST 35
#macro SNIPER_DMG 48
#macro SNIPER_RANGE 190
#macro SNIPER_FIRE_CD 180

#macro CANNON_COST 40
#macro CANNON_DMG 27
#macro CANNON_RANGE 85
#macro CANNON_FIRE_CD 135
#macro CANNON_AOE 55

#macro QUICKSAND_COST 10
#macro QUICKSAND_RANGE 90
#macro QUICKSAND_SLOW 0.775

#macro CELL 32

#macro WALL_COST 10
#macro WALL_PREMIUM 2

#macro CRATE_VALUE 25
#macro TEXT_SPEED 0.5
#macro SHOT_SND_GAP 3
#macro SELL_REFUND 0.5

enum GAME_STATE { TITLE, PLAY, OVER }
enum BUILD_CAT { PRODUCTION, OFFENSE }
enum BUILD { NONE, MENU, PLACING, UPGRADE, CONVERT }
enum MENU { MAIN, HOWTO, OPTIONS }

function wave_rise_rate(_w) {
    return WATER_BASE_RISE + (_w - 1) * WATER_RISE_STEP;
}
function wave_enemy_hp(_w) {
	return ENEMY_HP_BASE * power(1 + ENEMY_HP_GROWTH, _w - 1);
}

function wave_enemy_count(_w) {
    return 3 + (_w - 1) * 2;
}

function pickup_value(_w) {
    return round(PICKUP_VALUE * (1 + (_w - 1) * 0.2));
}