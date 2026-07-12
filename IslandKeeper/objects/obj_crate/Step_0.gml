if (global.state != GAME_STATE.PLAY) exit;
if (is_frozen()) exit;

var _ex = obj_game.island_r * (1 - global.water_level);
if (point_distance(obj_game.island_x, obj_game.island_y, x, y) > _ex) { instance_destroy(); exit; }

if (global.build != BUILD.NONE) exit;

if (instance_exists(obj_player) && point_distance(x, y, obj_player.x, obj_player.y) < 22) {
    var _obj, _nm;
    if (global.first_cargo) {
        global.first_cargo = false;
        _obj = obj_pump;
        _nm = "Pump";
    } else {
        var _r = irandom(3);
        _obj = (_r <= 1) ? obj_turret : (_r == 2 ? obj_sniper : obj_cannon);
        _nm  = (_obj == obj_turret) ? "Turret" : ((_obj == obj_sniper) ? "Sniper" : "Cannon");
    }

    global.build_obj  = _obj;
    global.build_cost = 0;
    global.build      = BUILD.PLACING;

    float_text(x, y - 14, "AIRDROP: " + _nm, COL_GEM);
    spawn_particles(x, y, COL_GEM, 12);
    audio_play_sound(snd_pickup, 4, false, 1, 0, 0.8);
    add_shake(3);
    instance_destroy();
}