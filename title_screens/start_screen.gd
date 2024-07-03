extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("start_game"):
		Globals.lives = 3
		Globals.score = 0
		get_tree().change_scene_to_file("res://levels/level_1.tscn")
