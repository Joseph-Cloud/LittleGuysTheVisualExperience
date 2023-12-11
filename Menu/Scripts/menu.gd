extends Node


####### Audio bitties #######
# dict connecting simple names:resource paths
var SFX ={
	dong1		:	"res://Assets/Sounds/sfx-dong1.wav",
	"beep1"		:	"res://Assets/Sounds/sfx-beep1.wav",
	"rising1"	:	"res://Assets/Sounds/sfx-rising1.wav"}

""" unneeded debug
func ring_dong():
	print("ringing dong")

func beep():
	print("playing beep")

func play_sfx_rising1():
	print("playing beep")
"""

# spawn menu_sounds
func _ready():
	pass;

# to be fed a simple name (key) from the sfx dict
func play_sfx(sfx):
	$menu_sounds.play(SFX.get(sfx))

func _on_play_pressed():
	play_sfx("dong1")
	get_tree().change_scene_to_file("res://Levels/test_level.tscn")
	print("Loading test_level.tscn")

func _on_options_pressed():
	get_tree().change_scene_to_file("res://Menu/Scenes/Options_menu.tscn")
	play_sfx("beep1");
	print("Loading Options")

func _on_level_select_pressed():
	get_tree().change_scene_to_file("res://Menu/Scenes/Level_select_menu.tscn")
	play_sfx("rising1");
	print("Loading Level Select")

func _on_quit_pressed():
	get_tree().quit()
