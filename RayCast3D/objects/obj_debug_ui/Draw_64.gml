//riferimento del player
var player = instance_find(obj_player,0);
if(player == noone) exit;


// Controlla se la mappa esiste
if (!variable_global_exists("map")) exit;

// Non disegnare il GUI normale durante la battaglia
if (global.battle_active) exit;

// === MINIMAP (SPOSTATA IN ALTO A DESTRA) ===
var minimap_scale = 7;
var minimap_size = 16 * minimap_scale; // 80 pixel
var minimap_x = room_width - minimap_size - 10; // 10 pixel dal bordo destro
var minimap_y = 10;

// Disegna bordo minimap
draw_set_color(c_white);
draw_rectangle(minimap_x - 2, minimap_y - 2, minimap_x + minimap_size + 2, minimap_y + minimap_size + 2, true);

// Disegna tiles minimap
global.tile_colors = [
    c_black,     // 0 = vuoto
    c_white,     // 1 = muro base
    c_red,       // 2 = muro tipo 2
    c_blue,      // 3 = porta
    c_yellow     // 4 = chiave
];

for (var yy = 0; yy < 16; yy++) {
    for (var xx = 0; xx < 16; xx++) {
        var tile_id = global.map[yy][xx];
        
        if (tile_id == 0) {
            draw_set_color(c_black);
        } else if (tile_id >= 1 && tile_id < 100) {
            if (tile_id < array_length(global.tile_colors)) {
                draw_set_color(global.tile_colors[tile_id]);
            } else {
                draw_set_color(c_white);
            }
        } else {
            var obj_index = tile_id - 100 + 4;
            if (obj_index < array_length(global.tile_colors)) {
                draw_set_color(global.tile_colors[obj_index]);
            } else {
                draw_set_color(c_yellow);
            }
        }
        
        draw_rectangle(
            minimap_x + xx * minimap_scale, 
            minimap_y + yy * minimap_scale,
            minimap_x + (xx+1) * minimap_scale - 1, 
            minimap_y + (yy+1) * minimap_scale - 1, 
            false
        );
    }
}

// Disegna player sulla minimap
draw_set_color(c_lime);
var player_map_x = minimap_x + (player.px / 64) * minimap_scale;
var player_map_y = minimap_y + (player.py / 64) * minimap_scale;
draw_circle(player_map_x, player_map_y, 2, false);

// Disegna direzione
draw_line(
    player_map_x, 
    player_map_y,
    player_map_x + dcos(player.direction_angle) * 8,
    player_map_y - dsin(player.direction_angle) * 8
);

// === HP BAR (ALTO A SINISTRA - DARK SOULS STYLE) ===
var bar_x = 20;
var bar_y = 20;
var bar_width = 200;
var bar_height = 20;

// Background barra HP
draw_set_color(c_black);
draw_rectangle(bar_x - 2, bar_y - 2, bar_x + bar_width + 2, bar_y + bar_height + 2, false);

// Barra HP (rosso scuro per sfondo, rosso chiaro per HP)
draw_set_color(c_maroon);
draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, false);

var hp_percent = clamp(player.hp / player.max_hp, 0, 1);
draw_set_color(c_red);
draw_rectangle(bar_x, bar_y, bar_x + (bar_width * hp_percent), bar_y + bar_height, false);

// Bordo barra HP
draw_set_color(c_white);
draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, true);

// Testo HP
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_text(bar_x + bar_width/2, bar_y , string(floor(player.hp)) + " / " + string(floor(player.max_hp)));

// === MP BAR (SOTTO HP BAR) ===
var mp_bar_y = bar_y + bar_height + 8;

// Background barra MP
draw_set_color(c_black);
draw_rectangle(bar_x - 2, mp_bar_y - 2, bar_x + bar_width + 2, mp_bar_y + bar_height + 2, false);

// Barra MP (blu scuro per sfondo, blu chiaro per MP)
draw_set_color(c_navy);
draw_rectangle(bar_x, mp_bar_y, bar_x + bar_width, mp_bar_y + bar_height, false);

var mp_percent = clamp(player.mp / player.max_mp, 0, 1);
draw_set_color(c_blue);
draw_rectangle(bar_x, mp_bar_y, bar_x + (bar_width * mp_percent), mp_bar_y + bar_height, false);

// Bordo barra MP
draw_set_color(c_white);
draw_rectangle(bar_x, mp_bar_y, bar_x + bar_width, mp_bar_y + bar_height, true);

// Testo MP
draw_set_color(c_white);
draw_text(bar_x + bar_width/2, mp_bar_y, string(floor(player.mp)) + " / " + string(floor(player.max_mp)));

// Stats aggiuntive sotto le barre
//draw_set_halign(fa_left);
//draw_set_color(c_yellow);
//draw_text(bar_x, mp_bar_y + 30, "LVL " + string(floor(player.lvl)));
//draw_text(bar_x, mp_bar_y + 45, "ATK " + string(floor(player.atk)) + " | DEF " + string(floor(player.def)));

// Stats aggiuntive sotto le barre - DARK SOULS STYLE
var stat_y = mp_bar_y + 35;

draw_set_halign(fa_left);

// Sfondo semitrasparente
draw_set_color(c_black);
draw_set_alpha(0.5);
draw_rectangle(bar_x - 5, stat_y - 5, bar_x + 190, stat_y + 35, false);
draw_set_alpha(1);

// Separatori verticali sottili
draw_set_color(c_dkgray);
draw_line(bar_x + 60, stat_y, bar_x + 60, stat_y + 30);
draw_line(bar_x + 125, stat_y, bar_x + 125, stat_y + 30);

// LEVEL
draw_set_color(c_gray);
draw_text(bar_x + 5, stat_y, "LVL");
draw_set_color(c_yellow);
draw_text(bar_x + 5, stat_y + 12, string(floor(player.lvl)));

// ATK
draw_set_color(c_gray);
draw_text(bar_x + 70, stat_y, "ATK");
draw_set_color(c_red);
draw_text(bar_x + 70, stat_y + 12, string(floor(player.atk)));

// DEF
draw_set_color(c_gray);
draw_text(bar_x + 135, stat_y, "DEF");
draw_set_color(c_aqua);
draw_text(bar_x + 135, stat_y + 12, string(floor(player.def)));



// === INVENTARIO (BASSO A DESTRA - DARK SOULS STYLE) ===
var inv_x = room_width - 110;
var inv_y = room_height - 150;

// Background inventario
draw_set_color(c_black);
draw_set_alpha(0.7);
draw_rectangle(inv_x - 10, inv_y - 10, room_width - 10, room_height - 10, false);
draw_set_alpha(1);
draw_set_color(c_yellow);
draw_text(inv_x, inv_y, "INVENTORY");


// Bordo inventario
draw_set_color(c_white);
draw_rectangle(inv_x - 10, inv_y - 10, room_width - 10, room_height - 10, true);

// Slot items (4 slot esempio)
var slot_size = 40;
var slot_spacing = 10;

for (var i = 0; i < 4; i++) {
    var slot_x = inv_x + (i % 2) * (slot_size + slot_spacing);
    var slot_y = inv_y + floor(i / 2) * (slot_size + slot_spacing) + 40;
    
    // Slot vuoto
    draw_set_color(c_dkgray);
    draw_rectangle(slot_x, slot_y, slot_x + slot_size, slot_y + slot_size, false);
    draw_set_color(c_white);
    draw_rectangle(slot_x, slot_y, slot_x + slot_size, slot_y + slot_size, true);
}

var slot_size = 40;
var sprite_size = 64; // il tuo sprite
var slot_spacing = 10;

// Slot 0 (chiave)
if (player.has_key) {
    var slot_x = inv_x + (0 % 2) * (slot_size + slot_spacing);
    var slot_y = inv_y + floor(0 / 2) * (slot_size + slot_spacing) + 40;
    draw_sprite_ext(
        spr_key, 0,
        slot_x + slot_size/2 - sprite_size/2,
        slot_y + slot_size/2 - sprite_size/2,
        1, 1, 0, c_white, 0.5
    );
}

// Slot 1 (esempio: pozione)
if (player.has_potion) {
    var slot_x = inv_x + (1 % 2) * (slot_size + slot_spacing);
    var slot_y = inv_y + floor(1 / 2) * (slot_size + slot_spacing) + 40;
    draw_sprite_ext(
        spr_potion, 0,
        slot_x + slot_size/2 - sprite_size/2,
        slot_y + slot_size/2 - sprite_size/2,
        1, 1, 0, c_white, 0.5
    );
}

// Slot 2 (esempio: spada)
if (player.has_key) {
    var slot_x = inv_x + (2 % 2) * (slot_size + slot_spacing);
    var slot_y = inv_y + floor(2 / 2) * (slot_size + slot_spacing) + 40;
    draw_sprite_ext(
        spr_key, 0,
        slot_x + slot_size/2 - sprite_size/2,
        slot_y + slot_size/2 - sprite_size/2,
        1, 1, 0, c_white, 0.5
    );
}

// Slot 3 (esempio: scudo)
if (player.has_key) {
    var slot_x = inv_x + (3 % 2) * (slot_size + slot_spacing);
    var slot_y = inv_y + floor(3 / 2) * (slot_size + slot_spacing) + 40;
    draw_sprite_ext(
        spr_key, 0,
        slot_x + slot_size/2 - sprite_size/2,
        slot_y + slot_size/2 - sprite_size/2,
        1, 1, 0, c_white, 0.5
    );
}

// === INDICATORE INTERAZIONE (CENTRO BASSO) ===
draw_set_halign(fa_center);
if (instance_exists(obj_player)) {
    var interaction = player.current_interaction;
    
    if (interaction != noone) {
        draw_set_color(c_black);
        draw_set_alpha(0.7);
        draw_rectangle(room_width/2 - 150, room_height - 70, room_width/2 + 150, room_height - 40, false);
        draw_set_alpha(1);
        
        draw_set_color(c_yellow);
        var message = "";
        if (interaction.type == "object") {
            if (interaction.tile_id == 100) message = "[E] Raccogli Chiave";
            if (interaction.tile_id == 101) message = "[E] Raccogli Pozione";
        } else if (interaction.type == "door") {
            if (player.has_key) {
                message = "[E] Apri Porta";
            } else {
                message = "Serve una Chiave";
            }
        }
        
        draw_text(room_width / 2, room_height - 60, message);
    }
}

draw_set_halign(fa_left);