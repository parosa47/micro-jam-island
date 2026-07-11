function spawn_enemy(_x, _y, _idx) {
    var _def = global.enemy_defs[_idx];
    var _e = instance_create_layer(_x, _y, "Instances", obj_enemy);
    _e.hp_max  = wave_enemy_hp(global.wave) * _def.hp;
    _e.hp      = _e.hp_max;
    _e.spd_mult = _def.spd;
    _e.rad     = _def.rad;
    _e.col     = _def.col;
    _e.is_boss = _def.boss;
    _e.drop    = _def.drop;
    return _e;
}

function pick_enemy_type(_w) {
    var _r = random(1);
    var _p_fast = (_w >= 4) ? 0.25 : 0;
    var _p_tank = (_w >= 6) ? 0.20 : 0;
    if (_r < _p_tank) return 2;
    if (_r < _p_tank + _p_fast) return 1;
    return 0;
}