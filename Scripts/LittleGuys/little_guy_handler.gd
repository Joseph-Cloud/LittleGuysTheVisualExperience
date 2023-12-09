"""
Scripts for the containing entity of many 'LittleGuy' entities
NOTE: if what you're doing concerned a singular 'LittleGuy' put it in the little_guy.gd script
"""

extends Node2D

@onready var little_guy_scene = preload("res://LittleGuys/little_guy.tscn")
var quantity = 20

func _on_timer_timeout():
	var little_guy = little_guy_scene.instantiate()
	little_guy.position = position
	get_parent().add_child(little_guy)
	quantity -= 1
	if quantity == 0:
		$Timer.stop()
