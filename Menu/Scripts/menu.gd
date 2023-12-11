extends Node


func play():
	get_tree().change_scene_to_file("res://Levels/test_level.tscn")
	print("Loading test_level.tscn")

func open_options():
	get_tree().change_scene_to_file("res://Menu/Scenes/Options_menu.tscn")
	print("Loading Options")

func open_level_select():
	get_tree().change_scene_to_file("res://Menu/Scenes/Level_select_menu.tscn")
	print("Loading Level Select")


func _process(_delta_):
	# Play on spacebar or right click press
	if Input.is_action_just_pressed("command_guys_stop"):
		play()


# Connected signals for calling functions
func _on_play_pressed():
	play()

func _on_options_pressed():
	open_options()

func _on_level_select_pressed():
	open_level_select()

func _on_quit_pressed():
	get_tree().quit()
