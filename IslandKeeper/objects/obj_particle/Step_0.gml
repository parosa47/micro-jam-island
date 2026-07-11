if (is_frozen()) exit;
x += lengthdir_x(spd, dir);
y += lengthdir_y(spd, dir);
spd *= 0.9;
life -= 1;
if (life <= 0) instance_destroy();