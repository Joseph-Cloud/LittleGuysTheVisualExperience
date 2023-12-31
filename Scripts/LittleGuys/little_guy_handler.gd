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
var spring_list: Array[Dictionary] = []

var curr_leader_idx = -1

func _ready():
	if Global.SOFT_BODY_CONTROL:
		add_guys_to_scene(self, INITIAL_GUYS)
		reconstitue_soft_body()
	print(Global.DEBUG)

func _process(_delta):
	if Global.DEBUG:
		_check_for_debug_inputs()
		if Global.SOFT_BODY_CONTROL:
			queue_redraw()
		
func _draw():
	if Global.DEBUG and Global.SOFT_BODY_CONTROL:
		for spring in spring_list:
			if not spring_is_valid(spring):
				continue
			draw_line(spring["mass_point_one"].position, spring["mass_point_two"].position, Color(1, 1, 1), 5)
		
func _check_for_debug_inputs():
	if Input.is_action_just_pressed("debug_add_little_guy"):
		add_guys_to_scene(self, 1)
	elif Input.is_action_just_pressed("debug_kill_little_guy"):
		remove_most_recent_guy_from_scene()
	
func remove_most_recent_guy_from_scene():
	var guy_to_remove: Node = little_guys[-1]
	var parent: Node = self
	if guy_to_remove != null:
		var idx = guy_to_remove.get_index()
		parent.remove_child(parent.get_child(idx))
		guy_to_remove.queue_free()
		if Global.SOFT_BODY_CONTROL:
			reconstitue_soft_body()

func remove_guy_by_id(idx: int):
	var parent: Node = get_parent()
	parent.remove_child(parent.get_child(idx))

func _on_hazards_body_entered(body):
	if body.is_in_group("LittleGuy"):
		body.queue_free()

func _physics_process(_delta):
	if not Global.SOFT_BODY_CONTROL:
		return
	update_spring_forces()
	cull_little_guys_list()
	for i in range(len(little_guys)):
		var guy = little_guys[i]
		if not is_instance_valid(guy):
			little_guys.erase(guy)
			continue
		
	
func add_guys_to_scene(node, num_guys=0):
	for x in range(num_guys):
		var little_guy: Node = little_guy_scene.instantiate()
		little_guy.position = position
		node.add_child(little_guy)
		little_guy.add_to_group("LittleGuy")
		little_guys.append(little_guy)

	if Global.SOFT_BODY_CONTROL:
		reconstitue_soft_body()

func _on_timer_timeout():
	if len(little_guys) < INITIAL_GUYS:
		add_guys_to_scene(get_parent(), 1)
	else:
		$Timer.stop()

func create_spring_dict(guy_one, guy_two, rest_length, stiffness):
	return {
			"mass_point_one": guy_one,
			"mass_point_two": guy_two,
			"rest_length": rest_length,
			"stiffness": stiffness,
			"damping": .1,
			}

func update_spring_forces():
	for i in range(len(spring_list)):
		var spring = spring_list[i]
		if not spring_is_valid(spring):
			continue
		var pos_one = spring["mass_point_one"].position
		var pos_two = spring["mass_point_two"].position
		var distance = spring["mass_point_one"].position.distance_to(spring["mass_point_two"].position)
		var direction_vec = (pos_two - pos_one).normalized()
		var spring_force = (abs(distance) - spring["rest_length"]) * spring["stiffness"]
		var damping_force = direction_vec.dot(spring["mass_point_two"].velocity - spring["mass_point_one"].velocity) * spring["damping"]
		var total_spring_force = spring_force + damping_force
		spring["mass_point_one"].spring_force += direction_vec * total_spring_force
		spring["mass_point_two"].spring_force += -direction_vec * total_spring_force
	# (abs(B - A) - L0) * ks + ((B - A)/abs(B - A)) * (vB - vA) * kd
	
func reconstitue_soft_body():
	spring_list = []
	cull_little_guys_list()
	var n = len(little_guys)
	for i in range(len(little_guys) - 1):
		var link_spring = create_spring_dict(little_guys[i], little_guys[(i + 1)], 175, 5)
		var leader_spring = create_spring_dict(little_guys[i], little_guys[(i + 2) % n], 175, 5)
		spring_list.append(link_spring)
		spring_list.append(leader_spring)
	curr_leader_idx = -1
	
		
func cull_little_guys_list():
	var i = 0
	while i < len(little_guys):
		var guy = little_guys[i]
		if not is_instance_valid(guy):
			little_guys.remove_at(i)
		i += 1

func spring_is_valid(spring):
	if not is_instance_valid(spring["mass_point_one"]) or not is_instance_valid(spring["mass_point_two"]):
		return false
	if spring["mass_point_one"].status == 2 and spring["mass_point_two"].status == 2:
		return false
	return true
