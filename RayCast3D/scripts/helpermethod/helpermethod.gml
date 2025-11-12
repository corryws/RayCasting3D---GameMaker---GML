

//helper method
function is_wall(map_x, map_y)
{
    if(map_x < 0 || map_x >= 16 || map_y < 0 || map_y >= 16){
        return true;
    }
    
    var tile_id = global.map[map_y][map_x];
    // Solo valori 1-99 sono muri solidi
    return (tile_id > 0 && tile_id < 100);
}

function get_wall_sprite(map_x, map_y) {
    // Se siamo fuori mappa, muro di bordo
    if (map_x < 0 || map_x >= map_width || map_y < 0 || map_y >= map_height) {
        return spr_wall1;
    }
    
    var tile_id = global.map[map_y][map_x];
    
    // Solo muri (1-99)
    if (tile_id >= 1 && tile_id < 100 && tile_id < array_length(global.wall_sprites)) {
        return global.wall_sprites[tile_id];
    }
    
    return spr_wall1; // default
}

function get_object_sprite(tile_id) {
    var index = tile_id - 100;
    
    if (index >= 0 && index < array_length(global.object_sprites)) {
        return global.object_sprites[index];
    }
    
    return noone;
}

/// check_playerposition(player, sw, sh)
function check_playerposition(player, sw, sh)
{
    var grid_x = floor(player.px / 64);
    var grid_y = floor(player.py / 64);

    //if(grid_x > 3 && grid_y > 3)
    //{
    //    draw_gradient_scene2(sw, sh, c_purple, c_olive, c_teal, c_olive);
		
	//	//trasformo tutti gli 1 della mappa in 3 global.map[][];
	//	ChangeToA(4, 1); // tutti gli alberi diventano muri
    //}
    //else
    //{
    //    draw_gradient_scene2( sw, sh, #2F42F4, #2F7CF4, #FADBAD, #FADBAD);
		
	//	//trasformo tutti i 3 della mappa in 1 global.map[][];
	//	ChangeToA(1, 4); //tutti i muri diventano alberi
    //}
	
	draw_gradient_scene2( sw, sh, #2F42F4, #2F7CF4, #FADBAD, #FADBAD);
	check_map_transition(player);
}

function GenerateMap()
{
    // ✅ CORREZIONE: usa [j][i] invece di [j,i]
    var map_index = global.world_grid[global.world_j][global.world_i]; 

    switch (map_index)
    {
        case 0:
            global.map = global.map_0;
            show_debug_message(">>> Mappa caricata: map_0");
            break;
        case 1:
            global.map = global.map_1;
            show_debug_message(">>> Mappa caricata: map_1");
            break;
        case 2:
            global.map = global.map_2;
            show_debug_message(">>> Mappa caricata: map_2");
            break;
        default:
            show_debug_message(">>> ERRORE: Nessuna mappa in questa posizione!");
            break;
    }
}


/// check_map_transition(player)
function check_map_transition(player)
{
    var grid_x = floor(player.px / 64);
    var grid_y = floor(player.py / 64);

    var changed = false;
    var new_i = global.world_i;
    var new_j = global.world_j;

    // USCITA NORD (y <= 0) → vai SU nella world_grid (j--)
    if (grid_y <= 0 && global.world_j > 0) {
        // ✅ CORREZIONE: usa [j][i] invece di [j,i]
        if (global.world_grid[global.world_j - 1][global.world_i] != -1) {
            new_j = global.world_j - 1;
            changed = true;
        }
    }
    // USCITA SUD (y >= 15) → vai GIÙ nella world_grid (j++)
    else if (grid_y >= map_height - 1 && global.world_j < array_length(global.world_grid) - 1) {
        if (global.world_grid[global.world_j + 1][global.world_i] != -1) {
            new_j = global.world_j + 1;
            changed = true;
        }
    }
    // USCITA OVEST (x <= 0) → vai SINISTRA nella world_grid (i--)
    else if (grid_x <= 0 && global.world_i > 0) {
        if (global.world_grid[global.world_j][global.world_i - 1] != -1) {
            new_i = global.world_i - 1;
            changed = true;
        }
    }
    // USCITA EST (x >= 15) → vai DESTRA nella world_grid (i++)
    else if (grid_x >= map_width - 1 && global.world_i < array_length(global.world_grid[0]) - 1) {
        if (global.world_grid[global.world_j][global.world_i + 1] != -1) {
            new_i = global.world_i + 1;
            changed = true;
        }
    }

    if (changed) {
        // Aggiorna puntatori
        global.world_i = new_i;
        global.world_j = new_j;
        
        show_debug_message(">>> Posizione world_grid: [" + string(new_j) + "][" + string(new_i) + "]");
        
        // Carica nuova mappa
        GenerateMap();
        
        // ✅ Riposiziona player dal lato opposto
        if (grid_x <= 0) {
            player.px = (map_width - 2) * 64; // Da OVEST → spawna EST
        } else if (grid_x >= map_width - 1) {
            player.px = 1 * 64; // Da EST → spawna OVEST
        }
        
        if (grid_y <= 0) {
            player.py = (map_height - 2) * 64; // Da NORD → spawna SUD
        } else if (grid_y >= map_height - 1) {
            player.py = 1 * 64; // Da SUD → spawna NORD
        }
    }
}



/// ChangeToA(da, a)
function ChangeToA(da, a)
{
    for (var i = 0; i < array_length_1d(global.map); i++)
    {
        for (var j = 0; j < array_length_1d(global.map[i]); j++)
        {
            if (global.map[i][j] == da)
                global.map[i][j] = a;
        }
    }
}



function check_interaction() {
    // Calcola la posizione davanti al player
    var check_dist = 64; // controlla 1 cella davanti
    var check_x = px + lengthdir_x(check_dist, direction_angle);
    var check_y = py + lengthdir_y(check_dist, direction_angle);
    
    // Converti in coordinate griglia
    var grid_x = floor(check_x / 64);
    var grid_y = floor(check_y / 64);
    
    // Controlla se siamo nei limiti
    if (grid_x < 0 || grid_x >= 16 || grid_y < 0 || grid_y >= 16) {
        return noone;
    }
    
    var tile_id = global.map[grid_y][grid_x];
    
    // Ritorna info sull'oggetto
    if (tile_id >= 100) {
        return {
            type: "object",
            tile_id: tile_id,
            grid_x: grid_x,
            grid_y: grid_y
        };
    } else if (tile_id == 3) { // porta
        return {
            type: "door",
            tile_id: tile_id,
            grid_x: grid_x,
            grid_y: grid_y
        };
    }
    
    return noone;
}

function interact_with(interaction) {
    if (interaction == noone) return;
    
    if (interaction.type == "object") {
        // Raccogli oggetto
        var tile_id = interaction.tile_id;
        
        switch(tile_id) {
            case 100: // Chiave
                has_key = true;
                show_debug_message("Hai raccolto una chiave!");
                // Rimuovi dalla mappa
                global.map[interaction.grid_y][interaction.grid_x] = 0;
                break;
                
            case 101: // Pozione
				has_potion = true;
				show_debug_message("Hai raccolto una pozione!");
                //hp = min(hp + 50, 100); // cura 50 HP
                //show_debug_message("Hai usato una pozione! HP: " + string(hp));
                global.map[interaction.grid_y][interaction.grid_x] = 0;
                break;
        }
        
        ds_list_add(collected_items, tile_id);
    } 
    else if (interaction.type == "door") {
        // Apri porta se hai la chiave
        if (has_key) {
            show_debug_message("Porta aperta!");
            global.map[interaction.grid_y][interaction.grid_x] = 0; // rimuovi porta
            has_key = false; // consuma la chiave (opzionale)
        } else {
            show_debug_message("Serve una chiave per aprire questa porta!");
        }
    }
}


//funzione per i gradient
function draw_gradient_rect(x1, y1, x2, y2, col_top, col_bottom) {
    draw_primitive_begin(pr_trianglefan);
    draw_vertex_color(x1, y1, col_top, 1);
    draw_vertex_color(x2, y1, col_top, 1);
    draw_vertex_color(x2, y2, col_bottom, 1);
    draw_vertex_color(x1, y2, col_bottom, 1);
    draw_primitive_end();
}

/// draw_gradient_scene(screen_width, screen_height, col_sky_top, col_sky_bottom, col_ground_top, col_ground_bottom)
function draw_gradient_scene2(sw, sh, sky_top, sky_bottom, ground_top, ground_bottom) {
    
    var horizon = sh/2; // linea di separazione cielo-terreno

    // --- CIELO ---
    draw_primitive_begin(pr_trianglefan);
    draw_vertex_color(0, 0, sky_top, 1);
    draw_vertex_color(sw, 0, sky_top, 1);
    draw_vertex_color(sw, horizon, sky_bottom, 1);
    draw_vertex_color(0, horizon, sky_bottom, 1);
    draw_primitive_end();

    // --- TERRENO CON "RUMORE" ---
    draw_primitive_begin(pr_trianglefan);

    // definisci una variazione per il rumore
    var noise_strength = 5;

    // vertici con rumore
    draw_vertex_color(0, horizon + random_range(-noise_strength, noise_strength), ground_top, 1);
    draw_vertex_color(sw, horizon + random_range(-noise_strength, noise_strength), ground_top, 1);
    draw_vertex_color(sw, sh, ground_bottom, 1);
    draw_vertex_color(0, sh, ground_bottom, 1);

    draw_primitive_end();
}



