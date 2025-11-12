// Gestione input durante battaglia
if (global.battle_active && global.battle_state == BattleState.PLAYER_TURN) {
    
    // Navigazione menu
    if (keyboard_check_pressed(vk_up)) {
        global.battle_menu_index--;
        if (global.battle_menu_index < 0) global.battle_menu_index = 3;
    }
    if (keyboard_check_pressed(vk_down)) {
        global.battle_menu_index++;
        if (global.battle_menu_index > 3) global.battle_menu_index = 0;
    }
    
    // Conferma azione
    if (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_enter)) {
        switch(global.battle_menu_index) {
            case 0: // Combatti
                global.battle_state = BattleState.ENEMY_TURN;
                PlayerAttack();
                break;
            case 1: // Magia
                global.battle_message = "Non hai magie!";
                global.battle_message_timer = 60;
                break;
            case 2: // Oggetti
                global.battle_message = "Non hai oggetti!";
                global.battle_message_timer = 60;
                break;
            case 3: // Fuggi
                TryFlee();
                break;
        }
    }
}

// Timer messaggio
if (global.battle_message_timer > 0) {
    global.battle_message_timer--;
}