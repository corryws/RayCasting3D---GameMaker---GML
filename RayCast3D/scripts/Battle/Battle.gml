// inizializzazione
global.step = irandom_range(50,255);

// resetta il passo
function InitStep()
{	
	//show_debug_message("BATTLE START!");
    global.step = irandom_range(50,255);
}

// decrementa il passo e resetta se arriva a 0
//function ManageStep(_px,_py)
//{
//    if(global.step <= 0) InitStep();
	
//	if(_px != 0 || _py != 0) global.step--;
//}
function ManageStep(_px, _py)
{
    // Se battaglia attiva, non fare nulla
    if (global.battle_active) return;
    
    if(global.step <= 0) {
        StartBattle(); // Avvia battaglia
        return;
    }
	
	var player = instance_find(obj_player,0);
	if(player == noone) exit;
	
	var map_x = floor(player.px / 64);
	var map_y = floor(player.py / 64);
	
	var tile_id = global.map[map_y][map_x];
	
	//show_debug_message("map_x " + string(map_x));
	//show_debug_message("map_y " + string(map_y));
	//show_debug_message("tile_id " + string(tile_id));
	//show_debug_message("global map manage step " + string(global.map[map_y][map_x]));
	show_debug_message("global.step " + string(global.step));
	
    if(_px != 0 && _py != 0 && tile_id == 103) global.step--;
}
