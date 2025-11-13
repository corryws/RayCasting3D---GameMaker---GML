// inizializzazione
global.step = irandom_range(50,255);

// resetta il passo
function InitStep()
{	
	show_debug_message("BATTLE START!");
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
        //StartBattle(); // Avvia battaglia
        return;
    }
	
    if(_px != 0 || _py != 0) global.step--;
}
