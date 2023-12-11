"""
Scripts for individual 'LittleGuy' entities
"""

extends CharacterBody2D

# mass point vars for soft body
@export var mass = 3
var spring_force = Vector2.ZERO

@onready var shot_timer = $ShotTimer
@onready var sprite_2d = $Sprite2D
@onready var aiming_reticle = $AimingReticle

@export var moving_speed = 250
@export var move_degrade_dist = 100
@export var reticle_distance_multiplier = 1
@export var shot_speed_multiplier = 2
@export var max_shot_distance = Vector2(250,250)


enum {MOVING, AIMING, SHOT, STOPPED}
var status = MOVING
var cursor_pos


func _ready():
	aiming_reticle.hide()


func start_moving():
	status = MOVING
	sprite_2d.texture = load("res://Assets/lilguy.png")
	set_collision_mask_value(1, true)
	set_collision_mask_value(2, false)

func start_aiming():
	status = AIMING
	sprite_2d.texture = load("res://Assets/green_guy.png")
	aiming_reticle.show()

func get_shot():
	status = SHOT
	sprite_2d.texture = load("res://Assets/hotterguy.png")
	aiming_reticle.hide()
	shot_timer.start()
	set_collision_mask_value(1, false)
	set_collision_mask_value(2, true)

func freeze_movement():
	status = STOPPED
	sprite_2d.texture = load("res://Assets/blue_guy.png")


func _process(_delta):
	# 
	if Input.is_action_pressed("command_guys_stop"):
		if status == MOVING:
			freeze_movement()
	if Input.is_action_just_released("command_guys_stop"):
		if status == STOPPED:
			start_moving()
	# z_index = position.y  # Sorts sprites by y value. Flickers and looks kinda strange.


func _physics_process(_delta):
	var mouse_position = get_viewport().get_mouse_position()
	
	# Move towards the mouse position while MOVING
	if status == MOVING:
		if Global.SOFT_BODY_CONTROL:
			var distance = mouse_position.distance_to(position)
			var curr_speed = moving_speed / (move_degrade_dist / distance)
			var seek_force = (mouse_position - position).normalized() * curr_speed
			
			velocity = spring_force / mass + seek_force
			spring_force = Vector2.ZERO	
		else: 
			velocity = (mouse_position - position).normalized() * moving_speed
	
	# Hold left mouse button to be AIMING a shot!
	elif status == AIMING:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			cursor_pos = -1 * (mouse_position - position).clamp(-max_shot_distance, max_shot_distance) * reticle_distance_multiplier
			aiming_reticle.position = cursor_pos
		
		# Release left mouse while AIMING to fire a SHOT
		elif not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			get_shot()
			velocity = -1 * (mouse_position - position).clamp(-max_shot_distance, max_shot_distance) * shot_speed_multiplier
	
	# Stop moving if AIMING / STOPPED
	elif status == AIMING or status == STOPPED:
		velocity = Vector2.ZERO
	
	# Finally, do physics
	move_and_slide()


# When left clicked on, enter AIMING mode and stop moving
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and status != SHOT:
			start_aiming()


# Awhile after being shot, stop being shot and start MOVING again
func _on_shot_timer_timeout():
	start_moving()
	shot_timer.stop()


# Turn pink on mouse hover
func _on_mouse_entered():
	if status != SHOT:
		sprite_2d.texture = load("res://Assets/selectguy.png")
	
	# If holding SHIFT, allow painting multiple guys into AIMING mode with left click
	if Input.is_action_pressed("hold_select_multiple_guys"):
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and status != SHOT:
			start_aiming()


# Turn back from pink after mouse stops hovering
func _on_mouse_exited():
	if status == MOVING:
		start_moving()
	elif status == STOPPED:
		freeze_movement()
