var _col = COL_VEG_LIGHT;
var _dark = merge_colour(_col, c_black, 0.30);
var _len = 14;
var _wid = 10;
draw_triangle_colour(
    x + lengthdir_x(_len, facing), y + lengthdir_y(_len, facing),
    x + lengthdir_x(_wid, facing + 130), y + lengthdir_y(_wid, facing + 130),
    x + lengthdir_x(_wid, facing - 130), y + lengthdir_y(_wid, facing - 130),
    _col, _col, _dark, false);
	
if (aa_show > 0) {
    aa_show -= 1;
    if (instance_exists(aa_target)) {
        draw_set_colour(COL_GEM);
        draw_line_width(x, y, aa_target.x, aa_target.y, 2);
        draw_set_colour(c_white);
    }
}