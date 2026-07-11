function is_frozen() {
    return (global.build == BUILD.MENU || global.build == BUILD.UPGRADE);
}

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

function type_base_range(_obj) {
    if (_obj == obj_turret)    return TURRET_RANGE;
    if (_obj == obj_sniper)    return SNIPER_RANGE;
    if (_obj == obj_cannon)    return CANNON_RANGE;
    if (_obj == obj_quicksand) return QUICKSAND_RANGE;
    return 0;
}

function offensive_step() {
    if (global.state != GAME_STATE.PLAY) exit;
    if (is_frozen()) exit;
    var _ex = obj_game.island_r * (1 - global.water_level);
    if (point_distance(obj_game.island_x, obj_game.island_y, x, y) > _ex) { global.nav_dirty = true; instance_destroy(); exit; }
    var _range = base_range + (range_lvl - 1) * 30;
    fire_cd -= 1;
    if (fire_cd <= 0) {
        var _e = instance_nearest(x, y, obj_enemy);
        if (_e != noone && point_distance(x, y, _e.x, _e.y) < _range) {
            fire_cd = max(6, base_fire_cd - (rate_lvl - 1) * 4);
            var _b = instance_create_layer(x, y, "Instances", obj_projectile);
            _b.target = _e;
            _b.dmg = base_dmg * dmg_lvl;
            _b.aoe = aoe_radius;
            _b.col = proj_col;
            _b.spd = proj_speed;
            audio_play_sound(snd_shoot, 5, false, 1, 0, random_range(0.9, 1.1));
        }
    }
}

function offensive_draw() {
    var _s = 12;
    var _tl = merge_colour(COL_WOOD, c_white, 0.20);
    draw_rectangle_colour(x - _s, y - _s, x + _s, y + _s, _tl, _tl, COL_WOOD, COL_WOOD, false);
    var _e = instance_nearest(x, y, obj_enemy);
    var _ang = (_e != noone) ? point_direction(x, y, _e.x, _e.y) : 90;
    draw_set_colour(merge_colour(COL_WOOD, c_black, 0.35));
    draw_line_width(x, y, x + lengthdir_x(barrel_len, _ang), y + lengthdir_y(barrel_len, _ang), barrel_w);
    draw_set_colour(dot_col);
    draw_circle(x, y - 4, 2.5, false);
    draw_set_colour(c_white);
    draw_level_pips(x, y + 17, dmg_lvl + range_lvl + rate_lvl - 2);
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

function upg_stats(_b) {
    var _list = [];
    var _cost = round(_b.base_cost * bld_level(_b) * UPGRADE_COST_MULT);
    switch (_b.kind) {
        case "pump":
            array_push(_list, { id: "flow", label: "Flow", lvl: _b.level, cost: _cost });
            break;
        case "offensive":
            array_push(_list, { id: "dmg",   label: "Damage",    lvl: _b.dmg_lvl,   cost: _cost });
            array_push(_list, { id: "range", label: "Range",     lvl: _b.range_lvl, cost: _cost });
            array_push(_list, { id: "rate",  label: "Fire rate", lvl: _b.rate_lvl,  cost: _cost });
            break;
        case "aura":
            array_push(_list, { id: "slow",  label: "Slow",  lvl: _b.slow_lvl,  cost: _cost });
            array_push(_list, { id: "range", label: "Range", lvl: _b.range_lvl, cost: _cost });
            break;
    }
    return _list;
}

function upg_apply(_b, _id) {
    if (bld_level(_b) >= BUILD_MAX_LEVEL) return;
    var _cost = round(_b.base_cost * bld_level(_b) * UPGRADE_COST_MULT);
    if (global.resource < _cost) return;
    global.resource -= _cost;
    switch (_id) {
        case "flow":
            global.pump_capacity -= _b.flow;
            _b.level += 1;
            _b.flow = PUMP_FLOW * _b.level;
            global.pump_capacity += _b.flow;
            break;
        case "dmg":   _b.dmg_lvl += 1;   break;
        case "range": _b.range_lvl += 1; break;
        case "rate":  _b.rate_lvl += 1;  break;
        case "slow":  _b.slow_lvl += 1;  break;
    }
    add_shake(2);
}

function bld_level(_b) {
    switch (_b.kind) {
        case "pump":      return _b.level;
        case "offensive": return _b.dmg_lvl + _b.range_lvl + _b.rate_lvl - 2;
        case "aura":      return _b.slow_lvl + _b.range_lvl - 1;
    }
    return 1;
}

function grid_snap(_v) {
    return floor(_v / CELL) * CELL + CELL * 0.5;
}

function is_solid_type(_obj) {
    return (_obj == obj_turret || _obj == obj_sniper || _obj == obj_cannon);
}