"""
Scripts for individual 'LittleGuy' entities
"""

extends CharacterBody2D

@export var speed = 200
@export var THROW_SPEED_MULTIPLIER = 5

# Note (stejeda): It might be worth turning this into a state machine
var paused: bool
var throw_target: Vector2

func throw(pos: Vector2):
	throw_target = pos
	
func toggle_pause() -> bool:
	paused = !paused
	return paused

func _ready():
	paused = false
	throw_target = Vector2.ZERO

func _physics_process(delta):
	var scalar = 1
	if paused and throw_target == Vector2.ZERO:
		velocity = Vector2.ZERO
		return

	if throw_target != Vector2.ZERO:
		velocity = ( throw_target - position ).normalized() * speed * THROW_SPEED_MULTIPLIER
	else:
		var mouse_position = get_viewport().get_mouse_position()
		velocity = ( mouse_position - position ).normalized() * speed * scalar
	move_and_slide()
