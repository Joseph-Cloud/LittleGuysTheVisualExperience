"""
Scripts for individual 'LittleGuy' entities
"""

extends CharacterBody2D

@export var speed = 200

func _physics_process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	velocity = ( mouse_position - position ).normalized() * speed
	move_and_slide()
