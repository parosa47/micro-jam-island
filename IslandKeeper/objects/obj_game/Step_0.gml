if (global.state != GAME_STATE.PLAY) exit;

if (global.grace_t > 0) {
    global.grace_t -= 1;
} else {
    var _net = wave_rise_rate(global.wave) - global.pump_capacity;
    global.water_level += _net / GAME_FPS;
    global.water_level = clamp(global.water_level, 0, 1);
    if (global.water_level >= 1) global.state = GAME_STATE.OVER;
}