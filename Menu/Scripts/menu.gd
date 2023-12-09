extends Node


#used to call 
func _on_play_pressed():
	get_tree().change_scene_to_file("res://Levels/Scene_1.tscn")
	print("Loading Scene_1.tscn")

func _on_options_pressed():
	get_tree().change_scene_to_file("res://Menu/Scenes/Options_menu.tscn")
	print("Loading Options")

func _on_level_select_pressed():
	get_tree().change_scene_to_file("res://Menu/Scenes/Level_select_menu.tscn")
	print("Loading Level Select")

func _on_quit_pressed():
	get_tree().quit()
