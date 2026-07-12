function key_name(_k) {
    switch (_k) {
        case vk_up:      return "Up Arrow";
        case vk_down:    return "Down Arrow";
        case vk_left:    return "Left Arrow";
        case vk_right:   return "Right Arrow";
        case vk_space:   return "Space";
        case vk_shift:   return "Shift";
        case vk_control: return "Ctrl";
        case vk_enter:   return "Enter";
        default:
            if (_k >= 48 && _k <= 90) return chr(_k);
            return "Key " + string(_k);
    }
}

function menu_layout(_page) {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    var _cx = _gw / 2;
    var _list = [];
    if (_page == MENU.MAIN) {
        var _y = _gh / 2 - 20;
        array_push(_list, { id: "start",   x: _cx - 120, y: _y,       w: 240, h: 46, label: "START" });
        array_push(_list, { id: "howto",   x: _cx - 120, y: _y + 60,  w: 240, h: 46, label: "HOW TO PLAY" });
        array_push(_list, { id: "options", x: _cx - 120, y: _y + 120, w: 240, h: 46, label: "OPTIONS" });
    } else if (_page == MENU.HOWTO) {
        array_push(_list, { id: "back", x: _cx - -200, y: _gh - 78, w: 180, h: 42, label: "BACK" });
    } else if (_page == MENU.OPTIONS) {
        var _y = _gh / 2 - 120;
        array_push(_list, { id: "up",     x: _cx - 160, y: _y,       w: 320, h: 34, label: "up" });
        array_push(_list, { id: "down",   x: _cx - 160, y: _y + 42,  w: 320, h: 34, label: "down" });
        array_push(_list, { id: "left",   x: _cx - 160, y: _y + 84,  w: 320, h: 34, label: "left" });
        array_push(_list, { id: "right",  x: _cx - 160, y: _y + 126, w: 320, h: 34, label: "right" });
        array_push(_list, { id: "volume", x: _cx - 160, y: _y + 180, w: 320, h: 16, label: "volume" });
        array_push(_list, { id: "tut",    x: _cx - 160, y: _y + 212, w: 320, h: 34, label: "tut" });
        array_push(_list, { id: "back",   x: _cx - 90,  y: _y + 262, w: 180, h: 42, label: "BACK" });
    }
    return _list;
}

function draw_menu_button(_b, _label) {
    var _mgx = device_mouse_x_to_gui(0);
    var _mgy = device_mouse_y_to_gui(0);
    var _over = (_mgx > _b.x && _mgx < _b.x + _b.w && _mgy > _b.y && _mgy < _b.y + _b.h);
    draw_set_alpha(0.9);
    draw_set_colour(_over ? merge_colour(COL_METAL, c_white, 0.28) : merge_colour(COL_METAL, c_black, 0.30));
    draw_rectangle(_b.x, _b.y, _b.x + _b.w, _b.y + _b.h, false);
    draw_set_alpha(1);
    draw_set_colour(_over ? COL_SAND : merge_colour(c_white, c_black, 0.2));
    draw_rectangle(_b.x, _b.y, _b.x + _b.w, _b.y + _b.h, true);
    draw_set_colour(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(_b.x + _b.w / 2, _b.y + _b.h / 2, _label);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

function tut_text(_i) {
    switch (_i) {
        case 1: return "You washed ashore with nothing.\nThe sea is rising and will slowly drown this island.\nSurvive as many waves as you can.";
        case 2: return "MOVE with " + key_name(global.key_up) + " / " + key_name(global.key_left) + " / " + key_name(global.key_down) + " / " + key_name(global.key_right) + ".\nYou auto-attack the nearest enemy in range -\nbut touching an enemy hurts you, so keep your distance.";
        case 3: return "Press  B  to open the BUILD menu (it pauses time).\nEverything costs salvage, which you earn\nby killing enemies and grabbing airdrops.";
        case 4: return "PUMPS push the water back - your top priority.\nWatch the gauge (top-left): it shows how many\npumps you need for the next tide.";
        case 5: return "WALLS + TURRETS form a maze: enemies walk around walls,\nso line turrets along their path.\nEnemies target your PUMPS - defend them!";
        case 6: return "Every 3 wave a plane drops a FREE building -\nrun to the crate and grab it.\n\nHold the shore. Good luck!";
    }
    return "";
}