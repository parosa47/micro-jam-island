function is_frozen() {
    return (global.build == BUILD.MENU || global.build == BUILD.UPGRADE || global.build == BUILD.CONVERT || global.paused || global.tut > 0);
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
            _b.dmg = off_damage(base_dmg, dmg_lvl);
            _b.aoe = aoe_radius;
            _b.col = proj_col;
            _b.spd = proj_speed;
			if (global.sfx_on && global.shot_snd_t <= 0) {
                audio_play_sound(snd_shoot, 5, false, 0.7, 0, random_range(0.9, 1.1));
                global.shot_snd_t = SHOT_SND_GAP;
            }
        }
    }
}

function offensive_draw() {
    var _s = CELL * 0.5 - 1;;
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

function pump_flow(_level) {
    return PUMP_FLOW * _level;
}

function off_damage(_base, _lvl) {
    return _base * power(1 + OFF_DMG_GROWTH, _lvl - 1);
}

function upgrade_pump(_p) {
    if (_p.level >= BUILD_MAX_LEVEL) return;
    var _cost = round(_p.base_cost * _p.level * UPGRADE_COST_MULT);
    if (global.resource < _cost) return;
    global.resource -= _cost;
    global.pump_capacity -= _p.flow;
    _p.level += 1;
    _p.flow = pump_flow(_p.level);
    global.pump_capacity += _p.flow;
    add_shake(2);
}

function upg_stats(_b) {
    var _list = [];
    var _cost = round(_b.base_cost * bld_level(_b) * UPGRADE_COST_MULT);
    switch (_b.kind) {
        case "pump":
            array_push(_list, { id: "flow", label: "Flow",
                cur: string_format(_b.flow, 1, 3),
                nxt: string_format(pump_flow(_b.level + 1), 1, 3), cost: _cost });
            break;
        case "offensive":
            array_push(_list, { id: "dmg", label: "Damage",
                cur: string(round(off_damage(_b.base_dmg, _b.dmg_lvl))),
                nxt: string(round(off_damage(_b.base_dmg, _b.dmg_lvl + 1))), cost: _cost });
            array_push(_list, { id: "range", label: "Range",
                cur: string(_b.base_range + (_b.range_lvl - 1) * 30),
                nxt: string(_b.base_range + _b.range_lvl * 30), cost: _cost });
            var _cd0 = max(6, _b.base_fire_cd - (_b.rate_lvl - 1) * 4);
            var _cd1 = max(6, _b.base_fire_cd - _b.rate_lvl * 4);
            array_push(_list, { id: "rate", label: "Fire rate",
                cur: string_format(GAME_FPS / _cd0, 1, 1) + "/s",
                nxt: string_format(GAME_FPS / _cd1, 1, 1) + "/s", cost: _cost });
            break;
        case "aura":
            var _s0 = max(0.60, QUICKSAND_SLOW - (_b.slow_lvl - 1) * 0.025);
            var _s1 = max(0.60, QUICKSAND_SLOW - _b.slow_lvl * 0.025);
            array_push(_list, { id: "slow", label: "Slow",
                cur: string(round((1 - _s0) * 100)) + "%",
                nxt: string(round((1 - _s1) * 100)) + "%", cost: _cost });
            break;
    }
    return _list;
}

function upg_apply(_b, _id) {
    if (bld_level(_b) >= BUILD_MAX_LEVEL) return;
    var _cost = round(_b.base_cost * bld_level(_b) * UPGRADE_COST_MULT);
    if (global.resource < _cost) return;
    global.resource -= _cost;
	_b.invested += _cost;
    switch (_id) {
        case "flow":
            global.pump_capacity -= _b.flow;
            _b.level += 1;
            _b.flow = pump_flow(_b.level);
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
        case "aura": return _b.slow_lvl;
    }
    return 1;
}

function grid_snap(_v) {
    return floor(_v / CELL) * CELL + CELL * 0.5;
}

function is_solid_type(_obj) {
    return (_obj == obj_turret || _obj == obj_sniper || _obj == obj_cannon || _obj == obj_wall);
}

function convert_options() {
    var _opts = [];
    var _nd = array_length(global.build_defs);
    for (var i = 0; i < _nd; i++) {
        var _o = global.build_defs[i].obj;
        if (is_solid_type(_o) && _o != obj_wall) {
             array_push(_opts, { obj: _o, name: global.build_defs[i].name, cost: max(1, global.build_defs[i].cost - WALL_COST) });
        }
    }
    return _opts;
}

function type_stats(_obj) {
    if (_obj == obj_pump)      return "Flow " + string_format(PUMP_FLOW, 1, 3);
    if (_obj == obj_turret)    return "Dmg " + string(TURRET_DMG) + "  Rng " + string(TURRET_RANGE);
    if (_obj == obj_sniper)    return "Dmg " + string(SNIPER_DMG) + "  Rng " + string(SNIPER_RANGE);
    if (_obj == obj_cannon)    return "Dmg " + string(CANNON_DMG) + "  AoE";
    if (_obj == obj_quicksand) return "Slows enemies";
    if (_obj == obj_wall)      return "Blocks enemies";
    return "";
}

function player_blocked(_px, _py) {
    var _r = 9;
    var _half = CELL * 0.5;
    with (obj_building) {
        if (kind == "offensive" || kind == "wall") {
            var _nx = clamp(_px, x - _half, x + _half);
            var _ny = clamp(_py, y - _half, y + _half);
            if (point_distance(_px, _py, _nx, _ny) < _r) return true;
        }
    }
    return false;
}