//input movimento WASD
var move_x = 0;
var move_y = 0;

if(keyboard_check(ord("W")))
{
	move_x = lengthdir_x(move_speed, direction_angle);
	move_y = lengthdir_y(move_speed, direction_angle);
	//incremento lo step
	
}
if(keyboard_check(ord("S")))
{
	move_x = lengthdir_x(-move_speed, direction_angle);
	move_y = lengthdir_y(-move_speed, direction_angle);
}
if(keyboard_check(ord("A")))
{
	move_x = lengthdir_x(move_speed, direction_angle - 90);
	move_y = lengthdir_y(move_speed, direction_angle - 90);
}
if(keyboard_check(ord("D")))
{
	move_x = lengthdir_x(move_speed, direction_angle + 90);
	move_y = lengthdir_y(move_speed, direction_angle + 90);
}

// Controlla cosa c'è davanti (salva per usarlo dopo)
current_interaction = check_interaction();
// Controllo interazione (tasto E)
if (keyboard_check_pressed(ord("E"))) {
    var interaction = check_interaction();
    if (interaction != noone) {
        interact_with(interaction);
    }
}

//CALCOLO A QUEL PUNTO LA NUOVA POSIZIONE
var new_px = px + move_x;
var new_py = py + move_y;

//detectiamo la collisione in maniera semplificata
var grid_x = floor(new_px / 64);
var grid_y = floor(new_py / 64);

if(!is_wall(grid_x,grid_y))
{
	px = new_px;
	py = new_py;
	
	//se move_x è 0 non incremento step
	ManageStep(move_x,move_y);
}

//implementiamo la rotazione con frecce
if(keyboard_check(vk_left))
{
	direction_angle -= rot_speed;
}
if(keyboard_check(vk_right))
{
	direction_angle += rot_speed;
}

//manteniamo l'angolo tra lo 0 e i 360°
direction_angle = direction_angle mod 360;
if(direction_angle < 0) direction_angle += 360;