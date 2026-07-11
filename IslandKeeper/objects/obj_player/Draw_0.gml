var _col = COL_VEG_LIGHT;
var _dark = merge_colour(_col, c_black, 0.30);
var _len = 14;
var _wid = 10;
draw_triangle_colour(
    x + lengthdir_x(_len, facing), y + lengthdir_y(_len, facing),
    x + lengthdir_x(_wid, facing + 130), y + lengthdir_y(_wid, facing + 130),
    x + lengthdir_x(_wid, facing - 130), y + lengthdir_y(_wid, facing - 130),
    _col, _col, _dark, false);