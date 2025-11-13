//RAYCASTING
//riferimento del player
var player = instance_find(obj_player,0);
if(player == noone) exit;

//impostiamo i parametri dello schermo
var screen_width = room_width;
var screen_height = room_height;
var num_rays = screen_width;

//refresh ad ogni frame
draw_clear(c_black);

check_playerposition(player, room_width, room_height);

// =========================================

// All'inizio del Draw Event, PRIMA del for loop dei raggi
var z_buffer = array_create(screen_width, 999999);

//per ogni colonna dello schermo applicherò L'ALGORITMO DDA
for(var i = 0; i < num_rays; i++)
{
	//calcoliamo l'angolo del raggio seguente
	var camera_x = 2 * i / num_rays - 1;
	var ray_angle = player.direction_angle + camera_x * (player.fov / 2);
	
	//Troviamo la direzione del raggio
	var ray_dir_x = lengthdir_x(1, ray_angle);
	var ray_dir_y = lengthdir_y(1, ray_angle);
	
	//Posizione del player nella griglia 64*64
	var map_x = floor(player.px / 64);
	var map_y = floor(player.py / 64);
	
	//ALGORITMO DDA SETUP
	var side_dist_x; 
	var side_dist_y;
	var delta_dist_x = (ray_dir_x == 0) ? 999999 : abs(1 / ray_dir_x);
	var delta_dist_y = (ray_dir_y == 0) ? 999999 : abs(1 / ray_dir_y);
	
	var step_x, step_y;
	
	//Calcola step e distanza iniziali
	if(ray_dir_x < 0)
	{
		step_x = -1;
		side_dist_x = (player.px / 64 - map_x) * delta_dist_x;
	}else{
		step_x = 1;
		side_dist_x = (map_x + 1.0 - player.px / 64) * delta_dist_x;
	}
	
	if(ray_dir_y < 0)
	{
		step_y = -1;
		side_dist_y = (player.py / 64 - map_y) * delta_dist_y;
	}else{
		step_y = 1;
		side_dist_y = (map_y + 1.0 - player.py / 64) * delta_dist_y;
	}
	
	//ESEGUIAMO ORA IL DDA
	var hit = false;
	var side = 0;
	
	while(!hit)
	{
		//avanza nella griglia
		if(side_dist_x < side_dist_y)
		{
			side_dist_x += delta_dist_x;
			map_x += step_x;
			side = 0;
		}else{
			side_dist_y += delta_dist_y;
			map_y += step_y;
			side = 1;
		}
	
		if(map_x < 0 || map_x >= map_width || map_y < 0 || map_y >= map_height) {
			hit = true;
			break;
		}
	
		if(is_wall(map_x,map_y))
		{
			hit = true;	
		}
	}
	
	//calcoliamo ora la distanza
	var perp_wall_dist;
	if (side == 0) {
		perp_wall_dist = (side_dist_x - delta_dist_x);
	} else {
		perp_wall_dist = (side_dist_y - delta_dist_y);
	}
	
	// SALVA LA DISTANZA NEL Z-BUFFER
    z_buffer[i] = perp_wall_dist;
	
	// Calcola dove esattamente il muro è stato colpito
	var wall_x;
	if (side == 0) {
		wall_x = player.py/64 + perp_wall_dist * ray_dir_y;
	} else {
		wall_x = player.px/64 + perp_wall_dist * ray_dir_x;
	}
	wall_x -= floor(wall_x);
	
	// Calcola altezza della linea da disegnare
	var line_height = screen_height / perp_wall_dist;
	
	// Calcola posizione verticale
	var draw_start = -line_height / 2 + screen_height / 2;
	var draw_end = line_height / 2 + screen_height / 2;
	
	// Sprite del muro
	var spr = get_wall_sprite(map_x,map_y);
	var spr_w = sprite_get_width(spr);
	var spr_h = sprite_get_height(spr);
	
	// Calcola quale colonna della texture usare
	var tex_x = floor(wall_x * spr_w);
	
	// Assicurati che tex_x sia nei limiti
	if (tex_x < 0) tex_x = 0;
	if (tex_x >= spr_w) tex_x = spr_w - 1;
	
	// Calcola la scala verticale
	var tex_scale_y = line_height / spr_h;
	
	// Limita draw_start e draw_end allo schermo
	if(draw_start < 0) draw_start = 0;
	if(draw_end >= screen_height) draw_end = screen_height - 1;
	
	// Scurisci un lato per dare profondità
	var wall_color = c_white;//(side == 1) ? c_white : c_gray;
	
	// Disegna la colonna della texture
	draw_sprite_part_ext(
		spr,
		0,
		tex_x, 0,
		1, spr_h,
		i, draw_start,
		1, tex_scale_y,
		wall_color,
		1
	);
}
// <-- IL FOR DEI MURI FINISCE QUI!

// === RENDERING SPRITE/BILLBOARD ===
var sprites_list = ds_list_create();

// Trova tutti gli sprite da disegnare
for (var yy = 0; yy < map_height; yy++) {
    for (var xx = 0; xx < map_width; xx++) {
        var tile_id = global.map[yy][xx];
        
        if (tile_id >= 100) {
            var sprite_world_x = (xx + 0.5) * 64;
            var sprite_world_y = (yy + 0.5) * 64;
            
            var dx = sprite_world_x - player.px;
            var dy = sprite_world_y - player.py;
            var dist = sqrt(dx*dx + dy*dy);
            
            ds_list_add(sprites_list, [sprite_world_x, sprite_world_y, tile_id, dist]);
        }
    }
}

// Disegna gli sprite
for (var i = 0; i < ds_list_size(sprites_list); i++) {
    var sprite_info = sprites_list[| i];
    var sx = sprite_info[0];
    var sy = sprite_info[1];
    var tile_id = sprite_info[2];
    
    var rel_x = sx - player.px;
    var rel_y = sy - player.py;
    
    var forward_x = lengthdir_x(1, player.direction_angle);
    var forward_y = lengthdir_y(1, player.direction_angle);
    var right_x = lengthdir_x(1, player.direction_angle - 90);
    var right_y = lengthdir_y(1, player.direction_angle - 90);
    
    var cam_depth = rel_x * forward_x + rel_y * forward_y;
    var cam_side = rel_x * right_x + rel_y * right_y;
    
    if (cam_depth <= 0.5) continue;
    
    var fov_factor = tan(degtorad(player.fov / 2));
    var screen_x = screen_width / 2 - (cam_side / cam_depth) * (screen_width / 2) / fov_factor;
    
    var sprite_size = (screen_height / cam_depth) * 64;
    
    // CONTROLLA Z-BUFFER
    var sprite_start = max(0, floor(screen_x - sprite_size / 2));
    var sprite_end = min(screen_width - 1, ceil(screen_x + sprite_size / 2));
    var is_visible = false;
    
    // Converti cam_depth (distanza dall'occhio) in unità della griglia (come perp_wall_dist)
    var sprite_perp_dist = cam_depth / 64; // <-- CONVERSIONE IMPORTANTE!
    
    for (var check_x = sprite_start; check_x <= sprite_end; check_x++) {
        // Aggiungi un piccolo margine di tolleranza (0.1)
        if (sprite_perp_dist < z_buffer[check_x] + 0.1) {
            is_visible = true;
            break;
        }
    }
    
    if (!is_visible) continue;
    
    var spr = get_object_sprite(tile_id);
    if (spr == noone) spr = spr_key;
    
    var spr_w = sprite_get_width(spr);
    var spr_h = sprite_get_height(spr);
    
    var scale_x = sprite_size / spr_w;
    var scale_y = sprite_size / spr_h;
    
    draw_sprite_ext(
        spr, 0,
        screen_x,
        screen_height / 2,
        scale_x,
        scale_y,
        0,
        c_white,
        1
    );
}

ds_list_destroy(sprites_list);
