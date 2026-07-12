if (is_frozen()) exit;
x += spd;
if (!dropped && x >= obj_game.island_x) {
    dropped = true;
    var _cx = obj_game.island_x + random_range(-120, 120);
    var _cy = obj_game.island_y + random_range(-100, 100);
    instance_create_layer(_cx, _cy, "Instances", obj_crate);
}
if (x > room_width + 100) instance_destroy();