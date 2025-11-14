// ============================================
// SCRIPT: BattleSystem.gml - VERSIONE CORRETTA
// ============================================

// Enum per gli stati di battaglia
enum BattleState {
    NONE,           // 0
    ENTERING,       // 1
    PLAYER_TURN,    // 2
    ENEMY_TURN,     // 3
    VICTORY,        // 4
    DEFEAT,         // 5
    FLEEING         // 6
}

// Inizializza il sistema di battaglia globale
global.battle_active = false;
global.battle_state = BattleState.NONE;
global.battle_enemy = noone;
global.battle_message = "";
global.battle_message_timer = 0;
global.battle_menu_index = 0;

// Database nemici
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

// Lista nemici (usa i tuoi sprite)
global.enemy_list = [
    create_enemy("Bulbasaur", 8, 5, 2, 5, 10, spr_bulbasaur),
    create_enemy("Ivysaur", 15, 8, 4, 10, 20, spr_ivysaur),
    create_enemy("Venusaur", 30, 15, 8, 50, 100, spr_venusaur)
];

// Avvia una battaglia casuale - MODIFICATA
function StartBattle() {
    show_debug_message("=== INIZIO BATTAGLIA ===");
    
    global.battle_active = true;
    global.battle_state = BattleState.PLAYER_TURN; // DIRETTAMENTE A PLAYER_TURN
    
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
    global.battle_message_timer = 0; // NESSUN TIMER
    global.battle_menu_index = 0;
    
    show_debug_message("Nemico: " + global.battle_enemy.name);
    show_debug_message("Battle State: " + string(global.battle_state));
}

// Calcola danno
function CalculateDamage(_attack, _defense) {
    var damage = _attack - floor(_defense / 2);
    damage = max(1, damage + irandom_range(-2, 2));
    return damage;
}

// Azione: Attacco del player
function PlayerAttack() {
    show_debug_message("=== PLAYER ATTACCA ===");
    var player = instance_find(obj_player, 0);
    var damage = CalculateDamage(player.atk, global.battle_enemy.defense);
    global.battle_enemy.hp -= damage;
    
    global.battle_message = "Infliggi " + string(damage) + " danni!";
    global.battle_message_timer = 60;
    
    if (global.battle_enemy.hp <= 0) {
        global.battle_state = BattleState.VICTORY;
        global.battle_message = "Hai sconfitto " + global.battle_enemy.name + "!";
        
        // Usa l'oggetto battle controller per l'alarm
        with(obj_battle_controller) {
            alarm[1] = 120;
        }
    } else {
        global.battle_state = BattleState.ENEMY_TURN;
        with(obj_battle_controller) {
            alarm[0] = 60;
        }
    }
}

// Turno del nemico
function EnemyTurn() {
    show_debug_message("=== NEMICO ATTACCA ===");
    var player = instance_find(obj_player, 0);
    var damage = CalculateDamage(global.battle_enemy.attack, player.def);
    player.hp -= damage;
    
    global.battle_message = global.battle_enemy.name + " ti attacca! Subisci " + string(damage) + " danni!";
    global.battle_message_timer = 60;
    
    if (player.hp <= 0) {
        global.battle_state = BattleState.DEFEAT;
        global.battle_message = "Sei stato sconfitto...";
        with(obj_battle_controller) {
            alarm[2] = 120;
        }
    } else {
        global.battle_state = BattleState.PLAYER_TURN;
    }
}

// Tenta la fuga
function TryFlee() {
    show_debug_message("=== TENTATIVO DI FUGA ===");
    if (random(1) < 0.5) {
        global.battle_message = "Sei fuggito con successo!";
        global.battle_message_timer = 60;
        global.battle_state = BattleState.FLEEING;
        with(obj_battle_controller) {
            alarm[1] = 60;
        }
    } else {
        global.battle_message = "Non riesci a fuggire!";
        global.battle_message_timer = 60;
        global.battle_state = BattleState.ENEMY_TURN;
        with(obj_battle_controller) {
            alarm[0] = 60;
        }
    }
}