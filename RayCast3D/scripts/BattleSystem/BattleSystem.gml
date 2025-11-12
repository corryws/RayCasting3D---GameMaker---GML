// ============================================
// SCRIPT: BattleSystem.gml
// Sistema di battaglia stile Dragon Quest 1
// ============================================

// Enum per gli stati di battaglia
enum BattleState {
    NONE,
    ENTERING,
    PLAYER_TURN,
    ENEMY_TURN,
    VICTORY,
    DEFEAT,
    FLEEING
}

// Inizializza il sistema di battaglia globale
global.battle_active = false;
global.battle_state = BattleState.NONE;
global.battle_enemy = noone;
global.battle_message = "";
global.battle_message_timer = 0;
global.battle_menu_index = 0;

// Le statistiche del player sono già nell'obj_player
// Usa: obj_player.hp, obj_player.max_hp, obj_player.atk, obj_player.def, obj_player.lvl

// Database nemici (puoi espandere)
function create_enemy(_name, _hp, _attack, _defense, _exp, _gold, _sprite) {
    return {
        name: _name,
        hp: _hp,
        hp_max: _hp,
        attack: _attack,
        defense: _defense,
        exp: _exp,
        gold: _gold,
        sprite: _sprite
    };
}

// Lista nemici (esempi - sostituisci con i tuoi sprite)
global.enemy_list = [
    create_enemy("Slime", 8, 5, 2, 5, 10, spr_invisible),
    create_enemy("Skeleton", 15, 8, 4, 10, 20, spr_invisible),
    create_enemy("Dragon", 30, 15, 8, 50, 100, spr_invisible)
];

// Avvia una battaglia casuale
function StartBattle() {
    global.battle_active = true;
    global.battle_state = BattleState.ENTERING;
    
    // Seleziona nemico casuale
    var enemy_template = global.enemy_list[irandom(array_length(global.enemy_list) - 1)];
    
    // Crea copia del nemico
    global.battle_enemy = {
        name: enemy_template.name,
        hp: enemy_template.hp,
        hp_max: enemy_template.hp_max,
        attack: enemy_template.attack,
        defense: enemy_template.defense,
        exp: enemy_template.exp,
        gold: enemy_template.gold,
        sprite: enemy_template.sprite
    };
    
    global.battle_message = "Un " + global.battle_enemy.name + " appare!";
    global.battle_message_timer = 60;
    global.battle_menu_index = 0;
    
    alarm[0] = 60; // Dopo 1 secondo passa al turno del player
}

// Calcola danno
function CalculateDamage(_attack, _defense) {
    var damage = _attack - floor(_defense / 2);
    damage = max(1, damage + irandom_range(-2, 2)); // Variazione casuale
    return damage;
}

// Azione: Attacco del player
function PlayerAttack() {
    var player = instance_find(obj_player, 0);
    var damage = CalculateDamage(player.atk, global.battle_enemy.defense);
    global.battle_enemy.hp -= damage;
    
    global.battle_message = "Infliggi " + string(damage) + " danni!";
    global.battle_message_timer = 60;
    
    if (global.battle_enemy.hp <= 0) {
        global.battle_state = BattleState.VICTORY;
        global.battle_message = "Hai sconfitto " + global.battle_enemy.name + "!";
        alarm[1] = 120; // Dopo 2 secondi esci dalla battaglia
    } else {
        alarm[0] = 60; // Turno del nemico
    }
}

// Turno del nemico
function EnemyTurn() {
    var player = instance_find(obj_player, 0);
    var damage = CalculateDamage(global.battle_enemy.attack, player.def);
    player.hp -= damage;
    
    global.battle_message = global.battle_enemy.name + " ti attacca! Subisci " + string(damage) + " danni!";
    global.battle_message_timer = 60;
    
    if (player.hp <= 0) {
        global.battle_state = BattleState.DEFEAT;
        global.battle_message = "Sei stato sconfitto...";
        alarm[2] = 120; // Game over
    } else {
        global.battle_state = BattleState.PLAYER_TURN;
    }
}

// Tenta la fuga
function TryFlee() {
    if (random(1) < 0.5) {
        global.battle_message = "Sei fuggito con successo!";
        global.battle_message_timer = 60;
        global.battle_state = BattleState.FLEEING;
        alarm[1] = 60;
    } else {
        global.battle_message = "Non riesci a fuggire!";
        global.battle_message_timer = 60;
        alarm[0] = 60; // Turno del nemico
    }
}

// ============================================
// OBJECT: obj_battle_controller
// Create Event
// ============================================
/*
alarm[0] = -1;
alarm[1] = -1;
alarm[2] = -1;

// Alarm[0]: Turno nemico
// Metodo alternativo se non vuoi usare alarm nel player
*/

// ============================================
// OBJECT: obj_battle_controller
// Alarm[0] Event
// ============================================
/*
if (global.battle_state == BattleState.ENTERING) {
    global.battle_state = BattleState.PLAYER_TURN;
} else if (global.battle_active) {
    global.battle_state = BattleState.ENEMY_TURN;
    EnemyTurn();
}
*/

// ============================================
// OBJECT: obj_battle_controller
// Alarm[1] Event - Fine battaglia (vittoria/fuga)
// ============================================
/*
global.battle_active = false;
global.battle_state = BattleState.NONE;
global.battle_enemy = noone;
InitStep(); // Resetta il contatore step
*/

// ============================================
// OBJECT: obj_battle_controller
// Alarm[2] Event - Game Over
// ============================================
/*
game_restart();
*/

// ============================================
// OBJECT: obj_battle_controller
// Step Event
// ============================================
/*
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
*/

// ============================================
// OBJECT: obj_battle_controller
// Draw GUI Event
// ============================================
/*
if (!global.battle_active) exit;

var cam_w = camera_get_view_width(view_camera[0]);
var cam_h = camera_get_view_height(view_camera[0]);

// Sfondo nero semi-trasparente
draw_set_alpha(0.8);
draw_set_color(c_black);
draw_rectangle(0, 0, cam_w, cam_h, false);
draw_set_alpha(1);

// Box battaglia principale (stile Dragon Quest)
var box_x = cam_w / 2;
var box_y = cam_h * 0.3;
var box_w = cam_w * 0.8;
var box_h = cam_h * 0.5;

// Disegna bordo esterno
draw_set_color(c_white);
draw_rectangle(box_x - box_w/2, box_y - box_h/2, box_x + box_w/2, box_y + box_h/2, false);
draw_set_color(c_black);
draw_rectangle(box_x - box_w/2 + 4, box_y - box_h/2 + 4, box_x + box_w/2 - 4, box_y + box_h/2 - 4, false);

// Disegna nemico (centrato in alto)
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

// Menu comandi (solo durante turno player)
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

// Info player (in basso a sinistra)
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

// Reset draw settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
*/