var _c = (flash > 0) ? c_white : col;
if (flash > 0) flash -= 1;
draw_circle_colour(x, y, rad, merge_colour(_c, c_white, 0.15), _c, false);
if (is_boss) {
    draw_set_colour(COL_ALERT);
    draw_circle(x, y, rad + 4, true);
    draw_set_colour(c_white);
}