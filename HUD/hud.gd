extends CanvasLayer

#Coded by Paul Reynolds


func _ready():
	
	Globals.player_died.connect(lose_life)
	$Lives_Panel/Lives_Label.text = str(Globals.lives)
	
	


func lose_life():
	$Lives_Panel/Lives_Label.text = str(Globals.lives)
	
	
