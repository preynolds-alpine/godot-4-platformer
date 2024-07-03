extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("start_game"):
		get_tree().change_scene_to_file("res://title_screens/start_screen.tscn")
