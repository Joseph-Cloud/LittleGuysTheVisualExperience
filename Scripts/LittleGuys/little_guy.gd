"""
Scripts for individual 'LittleGuy' entities
"""

extends CharacterBody2D

@onready var shot_timer = $ShotTimer
@onready var sprite_2d = $Sprite2D

@export var speed = 200
@export var shot_speed = 4
@export var max_shot_speed = Vector2(500,500)

var animFrames = ["res://Assets/lilguy.png", "res://Assets/selectguy.png", "res://Assets/hotterguy.png"]

enum {MOVING, SHOOTING, SHOT}
var status = MOVING


func _physics_process(_delta):
	var mouse_position = get_viewport().get_mouse_position()
	
	# Move towards the mouse position while MOVING
	if status == MOVING:
		velocity = ( mouse_position - position ).normalized() * speed
		move_and_slide()
		
	# Release left mouse while SHOOTING to fire a SHOT
	elif status == SHOOTING and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		velocity = -1 * (mouse_position - position).clamp(-max_shot_speed, max_shot_speed) * shot_speed
		status = SHOT
		sprite_2d.texture = load(animFrames[2])
		shot_timer.start()
		move_and_slide()
	
	# If SHOT, continue moving along the shot vector
	elif status == SHOT:
		move_and_slide()


# When clicked on, enter SHOOTING aiming mode and stop moving
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and status == MOVING:
			#I have been clicked and am now SHOOTING...
			status = SHOOTING
			sprite_2d.texture = load(animFrames[1])


# Awhile after being shot, stop being shot and start MOVING again
func _on_shot_timer_timeout():
	if status == SHOT:
		status = MOVING
		sprite_2d.texture = load(animFrames[0])
