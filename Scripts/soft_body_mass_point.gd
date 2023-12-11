extends CharacterBody2D

# mass point vars for soft body
@export var mass = 3
var spring_force = Vector2.ZERO

func move():
	velocity = spring_force / mass
	spring_force = Vector2.ZERO
	move_and_slide()
