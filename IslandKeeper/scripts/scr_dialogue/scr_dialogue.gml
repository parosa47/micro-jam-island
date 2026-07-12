function say(_spk, _txt, _dur = -1) {
    if (_dur < 0) _dur = 100 + string_length(_txt) * 3;
    array_push(global.msg_queue, { spk: _spk, txt: _txt, dur: _dur });
}

function intro_dialogue() {
    say("RADIO", "Salt in my lungs. The plane is gone. I'm the only one who washed ashore.");
    say("RADIO", "The tide is climbing. This island is sinking, and I have nothing.");
    say("RADIO", "Dig. Build. Hold the water back. Just until they come for me.");
}

function radio_message(_w) {
    switch (_w) {
        case 1:
            say("RADIO", "...kzzt... survivor, do you copy? We have your distress call.");
            say("RADIO", "Hold position. A rescue team is being dispatched. You are not alone.");
        break;
        case 2: say("RADIO", "Supplies inbound. Use them to hold the shore. We're coming."); break;
        case 3: say("RADIO", "Storm rolling over the strait. Rescue delayed. Stay strong."); break;
        case 4: say("RADIO", "We have your coordinates. ETA unclear. Keep the signal alive."); break;
        case 5: say("RADIO", "We saw your flare. We're close now. Just hold on a little longer."); break;
        case 6: say("RADIO", "...say again? You're breaking up. We're-- ...kzzt..."); break;
        case 7:
            say("RADIO", "Hold position. A rescue team is being dispatched. You are not alone.");
            say("YOU", "...That's word for word. The exact same message.");
        break;
        case 8: say("YOU", "It's a loop. It has been a recording this whole time."); break;
        case 9: say("YOU", "No one is coming. No one was ever coming."); break;
        default: say("RADIO", "...kzzt... survivor, do you copy?..."); break;
    }
}