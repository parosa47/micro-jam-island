function draw_label(_x, _y, _text, _halign) {
    draw_set_font(fnt_ui);
    draw_set_valign(fa_top);
    draw_set_halign(_halign);
    var _w = string_width(_text);
    var _h = string_height(_text);
    var _px = (_halign == fa_left) ? _x : ((_halign == fa_right) ? _x - _w : _x - _w * 0.5);
    draw_set_alpha(0.55);
    draw_set_colour(c_black);
    draw_rectangle(_px - 7, _y - 4, _px + _w + 7, _y + _h + 4, false);
    draw_set_alpha(1);
    draw_set_colour(c_white);
    draw_text(_x, _y, _text);
}