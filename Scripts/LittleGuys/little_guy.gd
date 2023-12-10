"""
Scripts for individual 'LittleGuy' entities
"""

extends CharacterBody2D

@export var speed = 200

func _physics_process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	velocity = ( mouse_position - position ).normalized() * speed
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)


func _on_hazards_body_entered(body):
	if body.is_in_group("LittleGuy"):
		print("lava hit")
