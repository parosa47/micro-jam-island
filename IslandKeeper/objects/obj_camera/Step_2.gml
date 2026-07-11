if (!instance_exists(follow)) exit;
var _vw = camera_get_view_width(cam);
var _vh = camera_get_view_height(cam);
var _tx = clamp(follow.x - _vw * 0.5, 0, max(0, room_width - _vw));
var _ty = clamp(follow.y - _vh * 0.5, 0, max(0, room_height - _vh));
cam_x = lerp(cam_x, _tx, smooth);
cam_y = lerp(cam_y, _ty, smooth);
camera_set_view_pos(cam, floor(cam_x), floor(cam_y));