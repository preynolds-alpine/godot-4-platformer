extends CanvasLayer

#Coded by Paul Reynolds


func _ready():
	Globals.coin_collected.connect(update_coins)
	Globals.player_died.connect(lose_life)
	$Lives_Panel/Lives_Label.text = str(Globals.lives)
	$Coins_Panel/Score_Label.text = str(Globals.score)
	
func update_coins():
	Globals.score += 1
	$Coins_Panel/Score_Label.text = str(Globals.score)
	#if the score is divisible by 5 (every time we collect 5 coins)
	#add a life and update the hud
	if Globals.score % 5 == 0:
		Globals.lives += 1
		$Lives_Panel/Lives_Label.text = str(Globals.lives)

func lose_life():
	$Lives_Panel/Lives_Label.text = str(Globals.lives)
	
	
