if (global.battle_state == BattleState.ENTERING) {
    global.battle_state = BattleState.PLAYER_TURN;
} else if (global.battle_active) {
    global.battle_state = BattleState.ENEMY_TURN;
    EnemyTurn();
}