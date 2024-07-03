extends Area2D

#Coded by Paul Reynolds
#keep track of if the coin has been collected
var collected = false

#Make sure the coin collision layer is on objects and masked only with player layer
func _on_body_entered(body):
	if not collected:
		#Change collected to true so we can't collect again while sound is playing
		collected = true
		$AnimatedSprite2D.visible = false #Hide the coin animation
		Globals.coin_collected.emit()#tell the hud to update
		$Bling_Sound.play()
		await $Bling_Sound.finished #wait until the bling sound plays, then delete it
		queue_free()
