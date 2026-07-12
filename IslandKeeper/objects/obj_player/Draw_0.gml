var _mv = moving ? 1 : 0;
var _ls = sin(anim) * 3 * _mv;
var _as = cos(anim) * 2.5 * _mv;
var _bob = _mv ? (-abs(sin(anim)) * 1.5) : (sin(anim) * 0.6);

var _skin = make_colour_rgb(228, 184, 143);
var _vest = make_colour_rgb(232, 126, 38);
var _pant = make_colour_rgb(58, 68, 92);
var _hair = make_colour_rgb(64, 44, 32);
var _ol   = make_colour_rgb(28, 24, 30);

var _cx = x;
var _cy = y + _bob - jump_z;

var _shs = clamp(1 - jump_z / 45, 0.4, 1);
draw_set_alpha(0.28 * _shs);
draw_set_colour(c_black);
draw_ellipse(x - 8 * _shs, y + 12, x + 8 * _shs, y + 16, false);
draw_set_alpha(1);

draw_set_colour(_ol);
draw_line_width(_cx - 3, _cy + 4, _cx - 3 + _ls, _cy + 13, 5);
draw_line_width(_cx + 3, _cy + 4, _cx + 3 - _ls, _cy + 13, 5);
draw_set_colour(_pant);
draw_line_width(_cx - 3, _cy + 4, _cx - 3 + _ls, _cy + 13, 3);
draw_line_width(_cx + 3, _cy + 4, _cx + 3 - _ls, _cy + 13, 3);

draw_set_colour(_ol);
draw_line_width(_cx - 4, _cy - 3, _cx - 6 - _as, _cy + 5, 5);
draw_line_width(_cx + 4, _cy - 3, _cx + 6 + _as, _cy + 5, 5);
draw_set_colour(_skin);
draw_line_width(_cx - 4, _cy - 3, _cx - 6 - _as, _cy + 5, 2.5);
draw_line_width(_cx + 4, _cy - 3, _cx + 6 + _as, _cy + 5, 2.5);

draw_set_colour(_ol);
draw_roundrect_ext(_cx - 6, _cy - 7, _cx + 6, _cy + 5, 3, 3, false);
draw_set_colour(_vest);
draw_roundrect_ext(_cx - 5, _cy - 6, _cx + 5, _cy + 4, 3, 3, false);
draw_set_colour(merge_colour(_vest, c_black, 0.35));
draw_rectangle(_cx - 1.5, _cy - 6, _cx + 1.5, _cy + 4, false);

draw_set_colour(_ol);
draw_circle(_cx, _cy - 12, 6, false);
draw_set_colour(_skin);
draw_circle(_cx, _cy - 12, 5, false);
draw_set_colour(_hair);
draw_circle(_cx, _cy - 13.5, 4.5, false);
draw_set_colour(_skin);
draw_circle(_cx, _cy - 11, 4.3, false);

draw_set_colour(_ol);
draw_circle(_cx + face_x * 1.4 - 1.6, _cy - 11, 0.9, false);
draw_circle(_cx + face_x * 1.4 + 1.6, _cy - 11, 0.9, false);

draw_set_colour(c_white);
	
if (aa_show > 0) {
    aa_show -= 1;
    if (instance_exists(aa_target)) {
        draw_set_colour(COL_GEM);
        draw_line_width(x, y, aa_target.x, aa_target.y, 2);
        draw_set_colour(c_white);
    }
}

if (hurt_flash > 0) {
    draw_set_alpha(hurt_flash / 8);
    draw_set_colour(COL_ALERT);
    draw_circle(x, y, 16, false);
    draw_set_alpha(1);
    draw_set_colour(c_white);
}