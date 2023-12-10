extends Node


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Menu/Scenes/Main_menu.tscn")
	print("Loading Menu")


func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://Levels/test_level.tscn")
	print("Loading test_level.tscn")


func _on_level_2_pressed():
	get_tree().change_scene_to_file("res://Levels/Scene_1.tscn")
	print("Loading Scene_1.tscn")
