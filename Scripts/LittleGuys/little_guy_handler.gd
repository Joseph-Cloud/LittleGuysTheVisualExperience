"""
Scripts for the containing entity of many 'LittleGuy' entities
NOTE: if what you're doing concerns a singular 'LittleGuy' put it in the little_guy.gd script
"""

extends Node2D

# Note(stejeda): This may or may not work
signal kill_guy_by_id(little_guy_id)

@onready var little_guy_scene = preload("res://LittleGuys/little_guy.tscn")
var INITIAL_GUYS = 20
	# Note(stejeda): We need this assignment or the timer function will explode I think
var little_guys: Array[Node] = []

func _ready():

	little_guys = []
	print(Global.DEBUG)

func _process(delta):
	if Global.DEBUG:
		_check_for_debug_inputs()

func _check_for_debug_inputs():
	if Input.is_action_pressed("debug_add_little_guy"):
		add_guys_to_scene(get_parent(), 1)
	elif Input.is_action_just_pressed("debug_kill_little_guy"):
		remove_most_recent_guy_from_scene()

func remove_most_recent_guy_from_scene():
	var guy_to_remove: Node = little_guys[-1]
	var parent: Node = get_parent()
	if guy_to_remove != null:
		var idx = guy_to_remove.get_index()
		parent.remove_child(parent.get_child(idx))

func remove_guy_by_id(idx: int):
	var parent: Node = get_parent()
	parent.remove_child(parent.get_child(idx))

func add_guys_to_scene(node: Node, num_guys=0):
	for x in range(num_guys):
		var little_guy: Node = little_guy_scene.instantiate()
		little_guy.position = position
		node.add_child(little_guy)
		little_guy.add_to_group("LittleGuy")
		little_guys.append(little_guy)

func _on_timer_timeout():
	if len(little_guys) < INITIAL_GUYS:
		add_guys_to_scene(get_parent(), 1)
	else:
		$Timer.stop()

func _on_kill_guy_by_id(little_guy_id):
	remove_guy_by_id(little_guy_id)

func _on_hazards_body_entered(body):
	if body.is_in_group("LittleGuy"):
		body.queue_free()
