if (!global.battle_active) exit;

var cam_w = camera_get_view_width(view_camera[0]);
var cam_h = camera_get_view_height(view_camera[0]);

// Sfondo nero semi-trasparente
draw_set_alpha(0.8);
draw_set_color(c_black);
draw_rectangle(0, 0, cam_w, cam_h, false);
draw_set_alpha(1);

// Box battaglia principale
var box_x = cam_w / 2;
var box_y = cam_h * 0.3;
var box_w = cam_w * 0.8;
var box_h = cam_h * 0.5;

// Disegna bordo esterno
draw_set_color(c_white);
draw_rectangle(box_x - box_w/2, box_y - box_h/2, box_x + box_w/2, box_y + box_h/2, false);
draw_set_color(c_black);
draw_rectangle(box_x - box_w/2 + 4, box_y - box_h/2 + 4, box_x + box_w/2 - 4, box_y + box_h/2 - 4, false);

// Disegna nemico
if (global.battle_enemy != noone && sprite_exists(global.battle_enemy.sprite)) {
    draw_sprite(global.battle_enemy.sprite, 0, box_x, box_y - box_h/4);
}

// Nome nemico
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text(box_x, box_y - box_h/2 + 20, global.battle_enemy.name);

// HP nemico
var enemy_hp_text = "HP: " + string(global.battle_enemy.hp) + "/" + string(global.battle_enemy.hp_max);
draw_text(box_x, box_y - box_h/2 + 40, enemy_hp_text);

// Box messaggio
var msg_box_y = box_y + box_h/2 + 40;
draw_set_color(c_white);
draw_rectangle(20, msg_box_y, cam_w - 20, msg_box_y + 60, false);
draw_set_color(c_black);
draw_rectangle(24, msg_box_y + 4, cam_w - 24, msg_box_y + 56, false);

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_text(40, msg_box_y + 30, global.battle_message);

// Menu comandi
if (global.battle_state == BattleState.PLAYER_TURN && global.battle_message_timer <= 0) {
    var menu_x = cam_w - 200;
    var menu_y = msg_box_y + 80;
    
    // Box menu
    draw_set_color(c_white);
    draw_rectangle(menu_x - 10, menu_y - 10, menu_x + 180, menu_y + 110, false);
    draw_set_color(c_black);
    draw_rectangle(menu_x - 6, menu_y - 6, menu_x + 176, menu_y + 106, false);
    
    // Opzioni
    var menu_options = ["Combatti", "Magia", "Oggetti", "Fuggi"];
    for (var i = 0; i < 4; i++) {
        var col = (i == global.battle_menu_index) ? c_yellow : c_white;
        draw_set_color(col);
        var arrow = (i == global.battle_menu_index) ? "> " : "  ";
        draw_text(menu_x, menu_y + i * 25, arrow + menu_options[i]);
    }
}

// Info player
var player_info_x = 20;
var player_info_y = cam_h - 80;
var player = instance_find(obj_player, 0);

draw_set_color(c_white);
draw_rectangle(player_info_x, player_info_y, player_info_x + 200, player_info_y + 70, false);
draw_set_color(c_black);
draw_rectangle(player_info_x + 4, player_info_y + 4, player_info_x + 196, player_info_y + 66, false);

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_text(player_info_x + 10, player_info_y + 15, "HP: " + string(player.hp) + "/" + string(player.max_hp));
draw_text(player_info_x + 10, player_info_y + 35, "MP: " + string(player.mp) + "/" + string(player.max_mp));
draw_text(player_info_x + 10, player_info_y + 55, "LV: " + string(player.lvl));

// Reset
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);