"""
Scripts for individual 'LittleGuy' entities
"""

extends CharacterBody2D

@export var speed = 200
var paused: bool

func _throw(delta):
	print("I am being thrown")
	pass
	
func toggle_pause() -> bool:
	paused = !paused
	return paused

func _ready():
	paused = false	

func _physics_process(delta):
	if paused:
		velocity = Vector2.ZERO
		return
		
	var mouse_position = get_viewport().get_mouse_position()
	velocity = ( mouse_position - position ).normalized() * speed
	move_and_slide()
