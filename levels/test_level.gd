extends Node2D

#Coded by Paul Reynolds




func _on_fallzone_body_entered(body):
	#subtract one from lives and tell the HUD the player died
	Globals.lives -=1
	Globals.player_died.emit()
	#if player has no lives left, go to lose screen, otherwise start level again
	if Globals.lives <= 0:
		get_tree().change_scene_to_file("res://title_screens/lose_screen.tscn")
	else:
		get_tree().change_scene_to_file("res://levels/test_level.tscn")
	


func _on_flag_body_entered(body):
	get_tree().change_scene_to_file("res://title_screens/win_screen.tscn")
