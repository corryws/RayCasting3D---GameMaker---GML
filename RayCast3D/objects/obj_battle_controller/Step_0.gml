// Timer messaggio
if (global.battle_message_timer > 0) {
    global.battle_message_timer--;
}

// Gestione input durante battaglia
if (global.battle_active && global.battle_state == BattleState.PLAYER_TURN) {
    
    show_debug_message("INPUT ATTIVO - Menu index: " + string(global.battle_menu_index));
    
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
        show_debug_message("AZIONE CONFERMATA: " + string(global.battle_menu_index));
        switch(global.battle_menu_index) {
            case 0: // Combatti
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