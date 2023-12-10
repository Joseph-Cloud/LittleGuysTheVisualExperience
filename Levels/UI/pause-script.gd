extends Node
#functionality for the buttons in the pause menu

@onready var main = $"../"

func _on_home_pressed():
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://Menu/Scenes/Main_menu.tscn")
	print("Loading Menu")


func _on_quit_button_button_up():
	get_tree().quit()


func _on_options_pressed():
	print("Need to work on this, will get this going once we get sound working")


func _on_close_button_up():
	main.pauseMenu()

