function add_shake(_amt) {
    with (obj_camera) shake = max(shake, _amt);
}

function spawn_particles(_x, _y, _col, _count) {
    repeat (_count) {
        var _p = instance_create_layer(_x, _y, "Instances", obj_particle);
        _p.col = _col;
    }
}