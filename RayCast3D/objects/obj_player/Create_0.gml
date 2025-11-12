px = 8*64;//128;
py = 3*64//128;

//direzione in gradi (0 = destra, 90 su, 180 sinistra,360 giù)
direction_angle = 270;

fov = 90;//FOV FIELD OF VIEW - CAMPO VISIVO

move_speed = 3;

rot_speed = 3;


//RPG STATS AND VARIABLES
max_hp = 100;
max_mp = 100;
hp = max_hp;             // salute iniziale
mp = max_mp;              // mana/energia magica

atk = 10;             // attacco base
def = 5;              // difesa base
lvl = 1;              // livello iniziale
statspoint = 0;       // punti statistica da distribuire

player_exp = 0;       // esperienza attuale
player_exp_next = 100;// esperienza necessaria per il prossimo livello

// crea l’oggetto Leveling
lev = Leveling();

// Sistema inventario
has_key = false;
has_potion = false;
collected_items = ds_list_create();

// Distanza massima per interagire
interact_distance = 128;//80; // circa 1.25 celle
current_interaction = noone; 

