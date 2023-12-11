extends CanvasLayer

@export var max_wiggle_degrees = 28
@export var rotation_direction = -1
@export var rotation_speed = 0.6

@onready var guy_counter = $GuyCounter
@onready var guy_sprite = $GuyCounter/GuySprite
@onready var guys_we_have = $"GuyCounter/Guys we have"
@onready var slash = $GuyCounter/Slash
@onready var total_guys = $"GuyCounter/Total guys"


func wiggle_guy_sprite():
	if guy_sprite.rotation_degrees >= max_wiggle_degrees:
		rotation_direction = -1
	if guy_sprite.rotation_degrees <= - max_wiggle_degrees:
		rotation_direction = 1
	guy_sprite.rotation_degrees += rotation_direction


func count_guys():
	var counted_guys = 0
	counted_guys = get_tree().get_nodes_in_group("LittleGuys")
	guys_we_have.text = str(len(counted_guys))


func _process(delta):
	wiggle_guy_sprite()
	count_guys()
