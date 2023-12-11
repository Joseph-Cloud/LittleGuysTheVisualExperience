extends CharacterBody2D

# mass point vars for soft body
@export var mass = 3
var spring_force = Vector2.ZERO
var move_speed = 400

func move():
	var mouse_position = get_viewport().get_mouse_position()
	var seek_force = (mouse_position - position).normalized() * move_speed
	velocity = spring_force / mass + seek_force
	spring_force = Vector2.ZERO
	move_and_slide()
