/// SCRIPT: Leveling_AddExp
/// _player = id del player
/// _amount = EXP da aggiungere

function Leveling_AddExp(_player, _amount) {
    _player.player_exp += _amount;
    show_debug_message("Aggiunti " + string(_amount) + " EXP. Totale: " + string(_player.player_exp));

    while (_player.player_exp >= _player.player_exp_next) {
        _player.player_exp -= _player.player_exp_next;
        show_debug_message("EXP raggiunto! Livello successivo...");
        Leveling_LevelUp(_player);
    }
}

/// SCRIPT: Leveling_LevelUp
function Leveling_LevelUp(_player) {
    _player.lvl += 1;
    _player.statspoint += 3;
    show_debug_message("LEVEL UP! Nuovo livello: " + string(_player.lvl) + 
                       ", Statspoint disponibili: " + string(_player.statspoint));

    _player.player_exp_next = floor(_player.player_exp_next * 1.2);
    show_debug_message("EXP per il prossimo livello: " + string(_player.player_exp_next));
}