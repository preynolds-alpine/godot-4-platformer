extends CharacterBody2D

#Coded by Paul Reynolds

#Variable Declarations
const SPEED = 100
const GRAVITY = 1000
var direction = 1
var can_die = true
var active = false #this will change when the enemy is on screen
var bullet = preload("res://enemy/enemy_bullet.tscn")
var enemy_death_scene = preload("res://enemy/enemy_death.tscn")
@export var shoot_time_min: int = 2
@export var shoot_time_max: int = 5

func _ready():
	#change the position of the edge checker to the edge of the feet
	$Edge_Checker.position.x = $Feet.shape.get_size().x * direction
	#make it so we can generate random numbers
	randomize()
	#Set the wait time to a new values for shooting and changing direction
	$Shoot_Timer.wait_time = randi_range(shoot_time_min, shoot_time_max )
	$Change_Direction_Timer.wait_time = randi_range(2, 7)
		
func _physics_process(delta):
	#only move and shoot if active -- on screen
	if active:
		enemy_falling(delta)
		enemy_move()
		move_and_slide()

func enemy_falling(delta):
	#add gravity if enemy not on floor
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		
func enemy_move():
	#if enemy hits the wall or gets to the edge so the edge checker is no longer colliding
	if is_on_wall() or not $Edge_Checker.is_colliding() and is_on_floor():
		change_direction()
	#move x direction
	velocity.x = direction * SPEED
	
		
func change_direction():
	direction *= -1
	$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h
	#Switch the position of the edge checker to the other side
	$Edge_Checker.position.x = $Feet.shape.get_size().x * direction
	

func _on_side_hurtbox_body_entered(body):
	if body.is_in_group("player"):
		can_die = false
		body.lose_life()#call the lose life function in the player scene
		$Cool_Down_Timer.start()




func _on_top_hitbox_body_entered(body):
	if body.is_in_group("player") and can_die:
		die() #call the die function

func die():
	#create death scene
	var new_death = enemy_death_scene.instantiate()
	new_death.transform = global_transform
	owner.add_child(new_death)#add the death scene to level
	queue_free()


func _on_bullet_hitbox_area_entered(area):
	if area.is_in_group("player_bullet"):
		die()#call the die function


func _on_cool_down_timer_timeout():
	can_die = true



func _on_visible_on_screen_notifier_2d_screen_entered():
	active = true 
	$Shoot_Timer.start()
	

func _on_visible_on_screen_notifier_2d_screen_exited():
	active = false 
	$Shoot_Timer.paused = true

func _on_shoot_timer_timeout():
	#create a new bullet object and add it to the level
	var new_bullet = bullet.instantiate()
	new_bullet.transform = $Muzzle.global_transform
	new_bullet.position.x += $Feet.shape.get_size().x / 2 * direction
	new_bullet.set_direction(direction)
	owner.add_child(new_bullet)
	$Shoot_Sound.play()
	#play the enemy's shoot animation
	$AnimatedSprite2D.play("shoot")
	await $AnimatedSprite2D.animation_finished
	#go back to playing walk
	$AnimatedSprite2D.play("walk")
	#create a new wait time with a random number between min and max
	$Shoot_Timer.wait_time = randi_range(shoot_time_min, shoot_time_max)
	


func _on_change_direction_timer_timeout():
	change_direction()#change the direction after timer goes off
	#create a new wait time for the direction timer
	$Change_Direction_Timer.wait_time = randi_range(2, 7)
