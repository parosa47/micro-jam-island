draw_set_colour(c_white);
var _grace = ceil(global.grace_t / GAME_FPS);
draw_text(12, 10, "res " + string(global.resource) + "   wave " + string(global.wave) + "   water " + string_format(global.water_level, 1, 2) + "   grace " + string(_grace));

if (global.state == GAME_STATE.OVER) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(display_get_gui_width() / 2, display_get_gui_height() / 2, "SUBMERGE");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

if (instance_number(obj_cache) > 0) {
    draw_text(12, 30, "Espace pres d'un tas pour creuser");
}