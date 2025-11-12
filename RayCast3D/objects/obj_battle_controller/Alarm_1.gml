if (global.battle_state == BattleState.VICTORY) {
    var player = instance_find(obj_player, 0);
    
    // Aggiungi esperienza
    player.player_exp += global.battle_enemy.exp;
    
    // Controlla level up
    if (player.player_exp >= player.player_exp_next) {
        player.lev.LevelUp();
    }
}

global.battle_active = false;
global.battle_state = BattleState.NONE;
global.battle_enemy = noone;
InitStep();