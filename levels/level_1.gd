extends Node2D


func _on_fallzone_body_entered(body):
	Globals.lives -=1
	Globals.player_died.emit()
	if Globals.lives <= 0:
		get_tree().change_scene_to_file("res://title_screens/lose_screen.tscn")
	else:
		get_tree().change_scene_to_file("res://levels/level_1.tscn")


func _on_flag_body_entered(body):
	get_tree().change_scene_to_file("res://title_screens/win_screen.tscn")
