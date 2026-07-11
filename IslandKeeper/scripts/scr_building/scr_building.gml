function tier_colour(_lv) {
    var _t = floor((_lv - 1) / 4);
    if (_t <= 0) return c_white;
    if (_t == 1) return make_colour_rgb(240, 150, 70);
    if (_t == 2) return make_colour_rgb(224, 73, 47);
    return make_colour_rgb(170, 100, 235);
}

function draw_level_pips(_x, _y, _total) {
    var _pc = ((_total - 1) mod 4) + 1;
    var _col = tier_colour(_total);
    for (var i = 0; i < _pc; i++) {
        draw_circle_colour(_x - (_pc - 1) * 3 + i * 6, _y, 1.5, _col, _col, false);
    }
}

function upgrade_pump(_p) {
    if (_p.level >= BUILD_MAX_LEVEL) return;
    var _cost = round(_p.base_cost * _p.level * UPGRADE_COST_MULT);
    if (global.resource < _cost) return;
    global.resource -= _cost;
    global.pump_capacity -= _p.flow;
    _p.level += 1;
    _p.flow = PUMP_FLOW * _p.level;
    global.pump_capacity += _p.flow;
    add_shake(2);
}

function upgrade_turret_stat(_t, _is_dmg) {
    var _lv = _is_dmg ? _t.dmg_lvl : _t.range_lvl;
    if (_lv >= BUILD_MAX_LEVEL) return;
    var _cost = round(_t.base_cost * _lv * UPGRADE_COST_MULT);
    if (global.resource < _cost) return;
    global.resource -= _cost;
    if (_is_dmg) _t.dmg_lvl += 1; else _t.range_lvl += 1;
    add_shake(2);
}