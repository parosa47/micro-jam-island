#macro GAME_FPS 60

#macro WATER_BASE_RISE 0.015
#macro WATER_RISE_GROWTH 0.30
#macro WATER_LOSE 0.9

#macro START_RESOURCE 0
#macro GRACE_SECONDS 20

#macro PUMP_HP 60
#macro PUMP_COST 15
#macro PUMP_FLOW 0.008

#macro TURRET_HP 45
#macro TURRET_COST 20
#macro TURRET_RANGE 250
#macro TURRET_FIRE_CD 25
#macro TURRET_DMG 8
#macro BUILD_MAX_LEVEL 8
#macro UPGRADE_COST_MULT 0.75

#macro ENEMY_HP_BASE 30
#macro ENEMY_HP_GROWTH 0.18
#macro PLAYER_AA_RANGE 130

#macro CACHE_COUNT 6
#macro CACHE_RESOURCE 10
#macro DIG_RANGE 28

#macro ENEMY_SPAWN_CD 90
#macro ENEMY_SPEED 1.1
#macro ENEMY_CONTACT_DMG 0.5
#macro PICKUP_VALUE 5

#macro WAVE_PAUSE 6
#macro AA_DMG_NORMAL 0.34
#macro AA_DMG_BOSS 0.02

#macro SNIPER_COST 35
#macro SNIPER_DMG 22
#macro SNIPER_RANGE 320
#macro SNIPER_FIRE_CD 75

#macro CANNON_COST 40
#macro CANNON_DMG 10
#macro CANNON_RANGE 170
#macro CANNON_FIRE_CD 70
#macro CANNON_AOE 55

#macro QUICKSAND_COST 25
#macro QUICKSAND_RANGE 90
#macro QUICKSAND_SLOW 0.55

enum GAME_STATE { TITLE, PLAY, OVER }
enum BUILD_CAT { PRODUCTION, OFFENSE }
enum BUILD { NONE, MENU, PLACING, UPGRADE }

function wave_rise_rate(_w) {
	return WATER_BASE_RISE * power(1 + WATER_RISE_GROWTH, _w - 1);
}
function wave_enemy_hp(_w) {
	return ENEMY_HP_BASE * power(1 + ENEMY_HP_GROWTH, _w - 1);
}

function wave_enemy_count(_w) {
    return 3 + (_w - 1) * 2;
}