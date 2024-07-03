extends Area2D

#Coded by Paul Reynolds
const SPEED = 1000
var direction = 1



func _physics_process(delta):
	#change the x position by speed and direction
	position.x += SPEED * delta * direction
	

func set_direction(dir):
	direction = dir

func _on_area_entered(area):
	queue_free()

func _on_body_entered(body):
	queue_free()
	



func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
