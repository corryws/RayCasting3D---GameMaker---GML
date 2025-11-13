show_debug_message("Alarm 0 triggered! State: " + string(global.battle_state));

if (global.battle_state == BattleState.ENTERING) {
    global.battle_state = BattleState.PLAYER_TURN;
    global.battle_message = "Cosa fai?";
    global.battle_message_timer = 0;
    show_debug_message("Passato a PLAYER_TURN");
} else if (global.battle_active) {
    global.battle_state = BattleState.ENEMY_TURN;
    EnemyTurn();
}