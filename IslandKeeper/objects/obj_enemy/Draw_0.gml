var _c = (flash > 0) ? c_white : COL_ENEMY;
if (flash > 0) flash -= 1;
draw_circle_colour(x, y, 9, merge_colour(_c, c_white, 0.15), _c, false);