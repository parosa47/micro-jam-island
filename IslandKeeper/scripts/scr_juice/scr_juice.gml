function add_shake(_amt) {
    with (obj_camera) shake = max(shake, _amt);
}

function spawn_particles(_x, _y, _col, _count) {
    repeat (_count) {
        var _p = instance_create_layer(_x, _y, "Instances", obj_particle);
        _p.col = _col;
    }
}

function float_text(_x, _y, _str, _col) {
    var _t = instance_create_layer(_x, _y, "Instances", obj_floattext);
    _t.txt = _str;
    _t.col = _col;
    return _t;
}

function draw_blob(_cx, _cy, _rad, _noise, _n, _col, _maxr = infinity, _maxnoise = undefined) {
    draw_primitive_begin(pr_trianglefan);
    draw_vertex_colour(_cx, _cy, _col, 1);
    for (var i = 0; i <= _n; i++) {
        var _ii = i mod _n;
        var _a = _ii / _n * 360;
        var _cap = is_undefined(_maxnoise) ? _maxr : _maxr * _maxnoise[_ii];
        var _rr = min(_rad * _noise[_ii], _cap);
        draw_vertex_colour(_cx + lengthdir_x(_rr, _a), _cy + lengthdir_y(_rr, _a), _col, 1);
    }
    draw_primitive_end();
}

function draw_ring(_cx, _cy, _rin, _rout, _noise, _n, _col) {
    draw_primitive_begin(pr_trianglestrip);
    for (var i = 0; i <= _n; i++) {
        var _ii = i mod _n;
        var _a = _ii / _n * 360;
        var _ri = _rin * _noise[_ii];
        var _ro = _rout * _noise[_ii];
        draw_vertex_colour(_cx + lengthdir_x(_ri, _a), _cy + lengthdir_y(_ri, _a), _col, 1);
        draw_vertex_colour(_cx + lengthdir_x(_ro, _a), _cy + lengthdir_y(_ro, _a), _col, 1);
    }
    draw_primitive_end();
}

function draw_palm(_x, _y, _s) {
    draw_set_colour(merge_colour(COL_WOOD, c_black, 0.1));
    draw_line_width(_x, _y, _x - _s * 0.2, _y - _s, max(2, _s * 0.22));
    var _tx = _x - _s * 0.2, _ty = _y - _s;
    var _fr = _s * 0.85;
    draw_set_colour(COL_VEG_DARK);
    draw_line_width(_tx, _ty, _tx - _fr,       _ty - _fr * 0.2, max(2, _s * 0.16));
    draw_line_width(_tx, _ty, _tx - _fr * 0.7, _ty + _fr * 0.5, max(2, _s * 0.16));
    draw_line_width(_tx, _ty, _tx + _fr,       _ty - _fr * 0.2, max(2, _s * 0.16));
    draw_line_width(_tx, _ty, _tx + _fr * 0.7, _ty + _fr * 0.5, max(2, _s * 0.16));
    draw_line_width(_tx, _ty, _tx,             _ty - _fr * 0.6, max(2, _s * 0.16));
    draw_set_colour(merge_colour(COL_WOOD, c_black, 0.3));
    draw_circle(_tx, _ty, _s * 0.14, false);
    draw_set_colour(c_white);
}

