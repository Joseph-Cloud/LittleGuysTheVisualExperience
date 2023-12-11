extends Node2D

var mass_points: Array[Node] = []
var spring_list: Array[Dictionary] = []

func _physics_process(delta):
	update_spring_forces()
	cull_mass_points()
	var i = 0
	while i < len(mass_points):
		var mass_point = mass_points[i]
		if not is_instance_valid(mass_points):
			mass_points.remove_at(i)
		i += 1

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

func create_spring_dict(guy_one, guy_two, rest_length, stiffness):
	return {
			"mass_point_one": guy_one,
			"mass_point_two": guy_two,
			"rest_length": rest_length,
			"stiffness": stiffness,
			"damping": .1,
			}

func cull_mass_points():
	var i = 0
	while i < len(mass_points):
		var mass_point = mass_points[i]
		if not is_instance_valid(mass_point):
			mass_points.remove_at(i)
		i += 1
		
func spring_is_valid(spring):
	if not is_instance_valid(spring["mass_point_one"]) or not is_instance_valid(spring["mass_point_two"]):
		return false
	if spring["mass_point_one"].status == 2 and spring["mass_point_two"].status == 2:
		return false
	return true
	
func reconstitue_soft_body():
	spring_list = []
	cull_mass_points()
	var n = len(mass_points)
	for i in range(len(mass_points) - 1):
		var link_spring = create_spring_dict(mass_points[i], mass_points[(i + 1)], 175, 5)
		var leader_spring = create_spring_dict(mass_points[i], mass_points[(i + 2) % n], 175, 5)
		spring_list.append(link_spring)
		spring_list.append(leader_spring)
