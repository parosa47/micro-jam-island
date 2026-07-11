if (global.state != GAME_STATE.PLAY) exit;

if (global.grace_t > 0) {
    global.grace_t -= 1;
} else {
    var _net = wave_rise_rate(global.wave) - global.pump_capacity;
    global.water_level += _net / GAME_FPS;
    global.water_level = clamp(global.water_level, 0, 1);
    if (global.water_level >= WATER_LOSE) global.state = GAME_STATE.OVER;
}

if (global.grace_t <= 0) {
    if (wave_to_spawn > 0) {
        enemy_timer -= 1;
        if (enemy_timer <= 0) {
            enemy_timer = ENEMY_SPAWN_CD;
            var _a = random(360);
            instance_create_layer(island_x + lengthdir_x(island_r + 80, _a), island_y + lengthdir_y(island_r + 80, _a), "Instances", obj_enemy);
            wave_to_spawn -= 1;
        }
    } else if (instance_number(obj_enemy) == 0) {
        intermission_t -= 1;
        if (intermission_t <= 0) {
            global.wave += 1;
            wave_to_spawn = wave_enemy_count(global.wave);
            intermission_t = WAVE_PAUSE * GAME_FPS;
        }
    }
}