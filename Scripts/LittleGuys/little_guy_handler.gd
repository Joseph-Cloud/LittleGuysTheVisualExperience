"""
Scripts for the containing entity of many 'LittleGuy' entities
NOTE: if what you're doing concerns a singular 'LittleGuy' put it in the little_guy.gd script
"""

extends Node2D

@onready var little_guy_scene = preload("res://LittleGuys/little_guy.tscn")
var INITIAL_GUYS = 20
var total_guys

func _ready():
	total_guys = 0
	print(Global.DEBUG)
	
func add_guys_to_scene(node, num_guys=0):
	for x in range(num_guys):
		var little_guy = little_guy_scene.instantiate()
		little_guy.position = position
		node.add_child(little_guy)
		total_guys += 1

func _on_timer_timeout():
	if total_guys < INITIAL_GUYS:
		var little_guy = add_guys_to_scene(get_parent(), 1)
	else:
		$Timer.stop()
