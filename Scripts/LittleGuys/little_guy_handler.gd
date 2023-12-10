"""
Scripts for the containing entity of many 'LittleGuy' entities
NOTE: if what you're doing concerns a singular 'LittleGuy' put it in the little_guy.gd script
"""

extends Node2D

@onready var little_guy_scene = preload("res://LittleGuys/little_guy.tscn")
var INITIAL_GUYS = 100
var total_guys
var little_guys = []
var spring_list = []

var physics_ready = false

func _ready():
	total_guys = 0
	construct_soft_body(INITIAL_GUYS)
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
	
func _on_kill_guy_by_id(little_guy_id):
	remove_guy_by_id(little_guy_id)

func _on_hazards_body_entered(body):
	if body.is_in_group("LittleGuy"):
		body.queue_free()

func _physics_process(delta):
	update_spring_forces()
	for guy in little_guys:
		guy.physics_move(delta)
	
func add_guys_to_scene(node, num_guys=0):
	var angle_increment = 2 * PI / num_guys
	for x in range(num_guys):
		var little_guy = little_guy_scene.instantiate()
		var angle = x * angle_increment
		little_guy.position.x = position.x + num_guys * 10 * cos(angle)
		little_guy.position.y = position.y + num_guys * 10 * sin(angle)
		node.add_child(little_guy)
		little_guys.append(little_guy)
		total_guys += 1

func _on_timer_timeout():
	if total_guys < INITIAL_GUYS:
		var little_guy = add_guys_to_scene(get_parent(), 1)
	else:
		$Timer.stop()

func construct_soft_body(n):
	$Timer.stop()
	await add_guys_to_scene(self, n)
	#little_guys.back().is_leader = true
	for i in range(n):
		spring_list.append(create_spring_dict(little_guys[i], little_guys[(i + 1) % (n - 1)], 1))
		spring_list.append(create_spring_dict(little_guys[i], little_guys[(i + 2) % (n - 1)], 1))
		

func create_spring_dict(guy_one, guy_two, stiffness):
	return {
			"mass_point_one": guy_one,
			"mass_point_two": guy_two,
			"rest_length": 200,
			"stiffness": stiffness,
			"damping": .2,
			}

func update_spring_forces():
	for spring in spring_list:
		var pos_one = spring["mass_point_one"].position
		var pos_two = spring["mass_point_two"].position
		var distance = spring["mass_point_one"].position.distance_to(spring["mass_point_two"].position)
		var direction_vec = (pos_two - pos_one).normalized()
		var spring_force = (abs(distance) - spring["rest_length"]) * spring["stiffness"]
		var damping_force = direction_vec.dot(spring["mass_point_two"].velocity - spring["mass_point_one"].velocity) * spring["damping"]
		var total_spring_force = spring_force + damping_force
		spring["mass_point_one"].spring_force = direction_vec * total_spring_force
		spring["mass_point_two"].spring_force = -direction_vec * total_spring_force
	# (abs(B - A) - L0) * ks + ((B - A)/abs(B - A)) * (vB - vA) * kd
