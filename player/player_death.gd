extends AnimatedSprite2D

#Coded by Paul Reynolds
func _process(delta):
	await animation_finished
	queue_free()
	
	
