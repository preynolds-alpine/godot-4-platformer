extends CharacterBody2D

#Coded by Paul Reynolds

#constants and variables declared
const GRAVITY = 1000
const JUMP_SPEED = -600
const FRICTION = 25
const MAX_JUMPS = 2
const BOUNCE_SPEED = -500
var speed = 300
var current_state
var direction = 1
var jump_count = 0
var last_direction
var cool_down = true
var bullet = preload("res://player/player_bullet.tscn")
var death_scene = preload("res://player/player_death.tscn")
enum State {idle, walk, jump, shoot}
@onready var start_muzzle_position = $Muzzle.position.x
#this function runs when the player is loaded into a scene
func _ready():
	current_state = State.idle
	last_direction = 1

#this function is in the game's run loop and repeats continually	
func _physics_process(delta):
	player_falling(delta)#add gravity to player
	player_walk()#is the player moving left or right
	player_jump()#is the player jumping
	muzzle_position()#set the position of the muzzle
	player_shoot()#is the player shooting
	move_and_slide()#This will actually move the player to a new position
	player_animation()#change the player's animation
	#print("Current State: ", State.keys()[current_state])
	#print("Direction: ", direction)
	#print("Last Direction: ", last_direction)
func player_falling(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		current_state = State.idle
		jump_count = 0	


func player_walk():
	#get the inputs from the left and right keys
	direction = Input.get_axis("move_left","move_right")
	#If player is jumping, don't do this part and change to walking
	if current_state != State.jump:
		if direction != 0 and is_on_floor():
			current_state = State.walk
			velocity.x = direction * speed #change my x movement by direction and speed
			last_direction = direction #keep track of the last direction incase we stop moving
		else:
			velocity.x = move_toward(velocity.x, 0, FRICTION)
			

func player_animation():
	#check the current state and play the animation to match
	if current_state == State.idle:
		$AnimatedSprite2D.play("idle")
	elif current_state == State.walk:
		$AnimatedSprite2D.play("walk")
	elif current_state == State.jump:
		$AnimatedSprite2D.play("jump")
	elif current_state == State.shoot:
		$AnimatedSprite2D.play("shoot")
	#flip horizontally if facing different direction
	if last_direction < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false

		
func player_jump():
	#If the jump button is pressed and player isn't already in jump state
	#if not using jump_count and max jumps use not state jump and not state shoot
	if Input.is_action_just_pressed("jump") and jump_count < MAX_JUMPS:
		jump_count += 1
		current_state = State.jump
		velocity.y = JUMP_SPEED
	#keep player moving in the x direction if player is moving left or right
	if direction != 0:
		velocity.x = direction * speed#change my x movement by direction and speed
		last_direction = direction

func player_shoot():
	#only shoot if shoot button pressed and cooled down
	if Input.is_action_just_pressed("shoot") and cool_down:
		current_state = State.shoot
		$Cool_Down_Timer.start()#Start the cool down time
		var new_bullet = bullet.instantiate() #Create a new bullet object
		new_bullet.transform = $Muzzle.get_global_transform()#Move that new bullet to the Muzzle
		new_bullet.set_direction(last_direction)
		$Shoot_Sound.play()
		owner.add_child(new_bullet)#Add the bullet object to the level
		cool_down = false
	
func muzzle_position():
	#move the muzzle position if our direction changes
	#if the direction is positive, the muzzle position is positive
	#if the direction is negative, the muzzle position is negative
	if direction > 0:
		$Muzzle.position.x = start_muzzle_position
	elif direction < 0:
		$Muzzle.position.x = -start_muzzle_position

func _on_cool_down_timer_timeout():
	cool_down = true #reset cool down to true after timer ends


func _on_player_hitbox_area_entered(area):
	if area.is_in_group("enemy_bullet"):
		lose_life() #call the lose life function
		
		
		
		
func lose_life():
	Globals.lives -= 1 #Subtract a life from this variable
	velocity.y += BOUNCE_SPEED #move up for a bit when hit
	$Player_Hit_Sound.play()
	Globals.player_died.emit()#Tell the HUD to update
	if Globals.lives <= 0:
		lose_game()#if player has no lives call lose game function
	
func lose_game():
	var new_death_scene = death_scene.instantiate()#Create a death scene object
	new_death_scene.transform = global_transform#move that death scene object
	owner.add_child(new_death_scene)#add the death scene to the level
	$AnimatedSprite2D.hide()#Hide player animation while death scene plays
	await new_death_scene.animation_finished 
	get_tree().change_scene_to_file("res://title_screens/lose_screen.tscn")
