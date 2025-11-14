if (!global.battle_active) exit;

// Usa le dimensioni della GUI (non della camera!)
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

//show_debug_message("Battle State: " + string(global.battle_state) + " | Timer: " + string(global.battle_message_timer));

// Sfondo nero semi-trasparente
draw_set_alpha(0.5);
draw_set_color(c_black);
draw_rectangle(0, 0, gui_w, gui_h, false);
draw_set_alpha(1);

// Box battaglia principale
var box_x = gui_w / 2;
var box_y = gui_h * 0.35;
var box_w = 600;
var box_h = 400;

// Bordo box battaglia
draw_set_color(c_white);

if (sprite_exists(battleground_1)) {
    // Disegna l'immagine scalata per riempire il box
    draw_sprite_stretched(
        battleground_1, 
        0, 
        box_x - box_w/2, 
        box_y - box_h/2, 
        box_w, 
        box_h
    );
} else {
    // Fallback: colore solido se l'immagine non esiste
    draw_set_color(make_color_rgb(48, 98, 48));
    draw_rectangle(box_x - box_w/2, box_y - box_h/2, box_x + box_w/2, box_y + box_h/2, false);
}


// Disegna nemico
if (global.battle_enemy != noone && sprite_exists(global.battle_enemy.sprite)) {
    draw_sprite_ext(
        global.battle_enemy.sprite, 
        0, 
        box_x-100, 
        box_y-64,
        3, 3,
        0, 
        c_white, 
        1
    );
}

// Nome nemico
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text(box_x, box_y - box_h/2 + 15,string_upper(global.battle_enemy.name));

// HP nemico
var enemy_bar_w = 150;
var enemy_bar_h = 15;
var enemy_bar_x = box_x - enemy_bar_w/2;
var enemy_bar_y = box_y - box_h/2 + 40;

draw_set_color(c_maroon);
draw_rectangle(enemy_bar_x, enemy_bar_y, enemy_bar_x + enemy_bar_w, enemy_bar_y + enemy_bar_h, false);

var enemy_hp_percent = clamp(global.battle_enemy.hp / global.battle_enemy.hp_max, 0, 1);
draw_set_color(c_green);
draw_rectangle(enemy_bar_x, enemy_bar_y, enemy_bar_x + (enemy_bar_w * enemy_hp_percent), enemy_bar_y + enemy_bar_h, false);

draw_set_color(c_white);
draw_rectangle(enemy_bar_x, enemy_bar_y, enemy_bar_x + enemy_bar_w, enemy_bar_y + enemy_bar_h, true);

draw_set_halign(fa_center);
draw_text(box_x, enemy_bar_y - 4, string(global.battle_enemy.hp) + "/" + string(global.battle_enemy.hp_max));

// Box messaggio
var msg_box_y = box_y + box_h/2 + 30;
var msg_box_h = 50;
var msg_box_x1 = 30;
var msg_box_x2 = gui_w - 30;

draw_set_color(c_black);
draw_set_alpha(0.7);
draw_rectangle(msg_box_x1, msg_box_y, msg_box_x2, msg_box_y + msg_box_h, false);
draw_set_alpha(1);
draw_set_color(c_white);
draw_rectangle(msg_box_x1, msg_box_y, msg_box_x2, msg_box_y + msg_box_h, true);

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_text(45, msg_box_y + msg_box_h/2, global.battle_message);

// ============ MENU COMANDI ============
// MOSTRA SEMPRE SE È PLAYER_TURN (per debug)
if (global.battle_state == BattleState.PLAYER_TURN) {
    var menu_x = gui_w - 180;
    var menu_y = msg_box_y + msg_box_h + 20;
    
    // Background menu
    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(menu_x - 15, menu_y - 15, menu_x + 165, menu_y + 115, false);
    draw_set_alpha(1);
    draw_set_color(c_yellow);
    draw_rectangle(menu_x - 15, menu_y - 15, menu_x + 165, menu_y + 115, true);
    
    // Opzioni menu
    var menu_options = ["COMBATTI", "MAGIA", "OGGETTI", "FUGGI"];
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    for (var i = 0; i < 4; i++) {
        var is_selected = (i == global.battle_menu_index);
        
        if (is_selected) {
            draw_set_color(c_yellow);
            draw_set_alpha(0.3);
            draw_rectangle(menu_x - 10, menu_y + i * 28 - 2, menu_x + 160, menu_y + i * 28 + 22, false);
            draw_set_alpha(1);
        }
        
        var col = is_selected ? c_yellow : c_white;
        draw_set_color(col);
        var arrow = is_selected ? "> " : "  ";
        draw_text(menu_x, menu_y + i * 28, arrow + menu_options[i]);
    }
}

// Info player
var player_info_x = 30;
var player_info_y = gui_h - 100;
var player = instance_find(obj_player, 0);

draw_set_color(c_black);
draw_set_alpha(0.8);
draw_rectangle(player_info_x - 10, player_info_y - 10, player_info_x + 210, player_info_y + 80, false);
draw_set_alpha(1);
draw_set_color(c_white);
draw_rectangle(player_info_x - 10, player_info_y - 10, player_info_x + 210, player_info_y + 80, true);

// Barra HP
var p_bar_w = 180;
var p_bar_h = 15;

draw_set_color(c_maroon);
draw_rectangle(player_info_x, player_info_y, player_info_x + p_bar_w, player_info_y + p_bar_h, false);

var p_hp_percent = clamp(player.hp / player.max_hp, 0, 1);
draw_set_color(c_red);
draw_rectangle(player_info_x, player_info_y, player_info_x + (p_bar_w * p_hp_percent), player_info_y + p_bar_h, false);

draw_set_color(c_white);
draw_rectangle(player_info_x, player_info_y, player_info_x + p_bar_w, player_info_y + p_bar_h, true);

draw_set_halign(fa_center);
draw_text(player_info_x + p_bar_w/2, player_info_y - 4 , string(floor(player.hp)) + "/" + string(floor(player.max_hp)));

// Barra MP
var p_mp_y = player_info_y + 20;

draw_set_color(c_navy);
draw_rectangle(player_info_x, p_mp_y, player_info_x + p_bar_w, p_mp_y + p_bar_h, false);

var p_mp_percent = clamp(player.mp / player.max_mp, 0, 1);
draw_set_color(c_blue);
draw_rectangle(player_info_x, p_mp_y, player_info_x + (p_bar_w * p_mp_percent), p_mp_y + p_bar_h, false);

draw_set_color(c_white);
draw_rectangle(player_info_x, p_mp_y, player_info_x + p_bar_w, p_mp_y + p_bar_h, true);

draw_set_halign(fa_center);
draw_text(player_info_x + p_bar_w/2, p_mp_y - 4 , string(floor(player.mp)) + "/" + string(floor(player.max_mp)));

// Stats
var stat_y = p_mp_y + 25;
draw_set_halign(fa_left);
draw_set_color(c_gray);
draw_text(player_info_x, stat_y, "LVL " + string(player.lvl) + " | ATK " + string(player.atk) + " | DEF " + string(player.def));

// Reset
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);