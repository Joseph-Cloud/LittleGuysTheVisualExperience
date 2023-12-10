"""
Scripts for individual 'LittleGuy' entities
"""

extends CharacterBody2D

@export var seek_speed = 200
@export var seek_degrade_dist = 400

# mass point vars for soft body
@export var mass = 1
var spring_force

func physics_move(delta):
	var mouse_position = get_viewport().get_mouse_position()
	var distance = mouse_position.distance_to(position)
	var seek_force = (mouse_position - position).normalized() * seek_speed / (200 / distance)
	var force = spring_force + seek_force
	velocity = force / mass
	move_and_slide()
	
	# 	force = 0
	#	force += spring_force
	#	velocity += force / mass * delta
	#	position += velocity * delta
