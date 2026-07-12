if (flash > 0) flash -= 1;
anim += 0.14 + spd_mult * 0.12;

var _f = face;
var _c  = (flash > 0) ? c_white : col;
var _dk = merge_colour(_c, c_black, 0.45);
var _lt = merge_colour(_c, c_white, 0.30);
var _s  = rad;
var _wig = sin(anim);

switch (kind) {
    case 0: // crabe
        draw_set_colour(_dk);
        for (var _i = -1; _i <= 1; _i++) {
            var _lx = x + lengthdir_x(_i * _s * 0.5, _f);
            var _ly = y + lengthdir_y(_i * _s * 0.5, _f);
            var _w = sin(anim + _i) * 3;
            draw_line_width(_lx, _ly, _lx + lengthdir_x(_s + 4, _f - 90) + lengthdir_x(_w, _f), _ly + lengthdir_y(_s + 4, _f - 90) + lengthdir_y(_w, _f), 2);
            draw_line_width(_lx, _ly, _lx + lengthdir_x(_s + 4, _f + 90) + lengthdir_x(_w, _f), _ly + lengthdir_y(_s + 4, _f + 90) + lengthdir_y(_w, _f), 2);
        }
        var _fx = x + lengthdir_x(_s, _f), _fy = y + lengthdir_y(_s, _f);
        draw_circle_colour(_fx + lengthdir_x(_s*0.5, _f-90), _fy + lengthdir_y(_s*0.5, _f-90), _s*0.4, _c, _dk, false);
        draw_circle_colour(_fx + lengthdir_x(_s*0.5, _f+90), _fy + lengthdir_y(_s*0.5, _f+90), _s*0.4, _c, _dk, false);
        draw_circle_colour(x, y, _s, _lt, _c, false);
        draw_set_colour(_dk); draw_circle(x, y, _s, true);
    break;

    case 1: // poisson rapide
        var _bx = x - lengthdir_x(_s*0.8, _f), _by = y - lengthdir_y(_s*0.8, _f);
        var _tw = _wig * _s * 0.8;
        draw_triangle_colour(
            _bx, _by,
            _bx - lengthdir_x(_s, _f) + lengthdir_x(_tw, _f+90), _by - lengthdir_y(_s, _f) + lengthdir_y(_tw, _f+90),
            _bx - lengthdir_x(_s, _f) - lengthdir_x(_tw, _f+90), _by - lengthdir_y(_s, _f) - lengthdir_y(_tw, _f+90),
            _c, _c, _dk, false);
        draw_circle_colour(x, y, _s, _lt, _c, false);
        draw_triangle_colour(
            x + lengthdir_x(_s*1.7, _f), y + lengthdir_y(_s*1.7, _f),
            x + lengthdir_x(_s*0.3, _f+90), y + lengthdir_y(_s*0.3, _f+90),
            x + lengthdir_x(_s*0.3, _f-90), y + lengthdir_y(_s*0.3, _f-90),
            _lt, _c, _c, false);
        draw_set_colour(_dk); draw_circle(x, y, _s, true);
    break;

    case 2: // blob tank
        var _p = _s * (1 + _wig * 0.07);
        draw_set_colour(_dk);
        for (var _i = 0; _i < 4; _i++) {
            var _la = _f + 120 + _i * 40;
            draw_line_width(x + lengthdir_x(_s*0.7, _la), y + lengthdir_y(_s*0.7, _la), x + lengthdir_x(_s+5, _la), y + lengthdir_y(_s+5, _la) + abs(_wig)*3, 3);
        }
        draw_circle_colour(x, y, _p, _lt, _c, false);
        draw_circle_colour(x - lengthdir_x(_s*0.3, _f), y - lengthdir_y(_s*0.3, _f), _p*0.65, merge_colour(_c, c_black, 0.25), merge_colour(_c, c_black, 0.45), false);
        draw_set_colour(_dk); draw_circle(x, y, _p, true);
    break;

    case 3: // boss kraken
        draw_set_colour(_dk);
        for (var _i = 0; _i < 7; _i++) {
            var _ta = _i * 51.4 + anim * 6;
            var _wv = sin(anim * 1.4 + _i) * _s * 0.35;
            var _m1x = x + lengthdir_x(_s*1.3, _ta) + lengthdir_x(_wv, _ta+90);
            var _m1y = y + lengthdir_y(_s*1.3, _ta) + lengthdir_y(_wv, _ta+90);
            var _t2x = x + lengthdir_x(_s*2.1, _ta) - lengthdir_x(_wv, _ta+90);
            var _t2y = y + lengthdir_y(_s*2.1, _ta) - lengthdir_y(_wv, _ta+90);
            draw_line_width(x + lengthdir_x(_s*0.7, _ta), y + lengthdir_y(_s*0.7, _ta), _m1x, _m1y, 5);
            draw_line_width(_m1x, _m1y, _t2x, _t2y, 3);
        }
        draw_circle_colour(x, y, _s, _lt, _c, false);
        draw_set_colour(_dk); draw_circle(x, y, _s, true);
    break;
}

if (kind == 3) {
    var _ex = x + lengthdir_x(_s*0.2, _f), _ey = y + lengthdir_y(_s*0.2, _f);
    draw_circle_colour(_ex, _ey, _s*0.42, c_white, c_white, false);
    draw_circle_colour(_ex + lengthdir_x(_s*0.15, _f), _ey + lengthdir_y(_s*0.15, _f), _s*0.22, c_black, c_black, false);
} else if (kind == 2) {
    for (var _i = -1; _i <= 1; _i++) {
        var _ex = x + lengthdir_x(_s*0.4, _f) + lengthdir_x(_i*_s*0.4, _f+90);
        var _ey = y + lengthdir_y(_s*0.4, _f) + lengthdir_y(_i*_s*0.4, _f+90);
        draw_circle_colour(_ex, _ey, _s*0.16, c_white, c_white, false);
        draw_circle_colour(_ex + lengthdir_x(_s*0.06, _f), _ey + lengthdir_y(_s*0.06, _f), _s*0.08, c_black, c_black, false);
    }
} else {
    var _ex = x + lengthdir_x(_s*0.5, _f), _ey = y + lengthdir_y(_s*0.5, _f);
    var _sx = lengthdir_x(_s*0.32, _f+90), _sy = lengthdir_y(_s*0.32, _f+90);
    var _px = lengthdir_x(_s*0.1, _f), _py = lengthdir_y(_s*0.1, _f);
    draw_circle_colour(_ex+_sx, _ey+_sy, _s*0.26, c_white, c_white, false);
    draw_circle_colour(_ex-_sx, _ey-_sy, _s*0.26, c_white, c_white, false);
    draw_circle_colour(_ex+_sx+_px, _ey+_sy+_py, _s*0.13, c_black, c_black, false);
    draw_circle_colour(_ex-_sx+_px, _ey-_sy+_py, _s*0.13, c_black, c_black, false);
}

if (is_boss) {
    draw_set_colour(COL_ALERT);
    draw_circle(x, y, _s + 8, true);
}
draw_set_colour(c_white);