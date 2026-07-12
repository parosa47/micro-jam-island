global.pump_capacity -= flow;
if (!global.selling) {
    add_shake(6);
    audio_play_sound(snd_pump_lost, 8, false);
}