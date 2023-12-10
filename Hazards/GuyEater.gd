extends Area2D

@onready var normal_frog_sprite = $NormalFrogSprite
@onready var happy_frog_sprite = $HappyFrogSprite

@onready var feed_me_label = $"SpeechBubbleSprite/Feed me"
@onready var num_of_guys_label = $SpeechBubbleSprite/NUMOFGUYS
@onready var guys_label = $"SpeechBubbleSprite/guys!"
@onready var win_text = $"SpeechBubbleSprite/win text"

@export var num_guys_to_eat = 10
var num_guys_eaten = 0
var full = false

# Called when the node enters the scene tree for the first time.
func _ready():
	win_text.hide()
	normal_frog_sprite.show()
	happy_frog_sprite.hide()
	num_of_guys_label.text = str(num_guys_to_eat)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if num_guys_eaten >= num_guys_to_eat and full == false:
		full = true
		feed_me_label.hide()
		num_of_guys_label.hide()
		guys_label.hide()
		win_text.show()
		normal_frog_sprite.hide()
		happy_frog_sprite.show()



func _on_body_entered(body):
	if body.is_in_group("LittleGuys") and full == false:
		num_guys_eaten += 1
		body.queue_free()
		num_of_guys_label.text = str(num_guys_to_eat - num_guys_eaten)
