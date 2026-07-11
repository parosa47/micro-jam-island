if (is_frozen()) exit;
var _ex = obj_game.island_r * (1 - global.water_level);
if (point_distance(obj_game.island_x, obj_game.island_y, x, y) > _ex) { global.nav_dirty = true; instance_destroy(); }