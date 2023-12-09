extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.





func _on_back_pressed():
	get_tree().change_scene_to_file("res://Menu/Scenes/Main_menu.tscn")
	print("Loading Menu")


func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://Levels/Scene_1.tscn")
	print("Loading Scene_1.tscn")
