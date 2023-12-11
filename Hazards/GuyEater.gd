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

func _ready():
	# Manage sprites / labels
	win_text.hide()
	normal_frog_sprite.show()
	happy_frog_sprite.hide()
	num_of_guys_label.text = str(num_guys_to_eat)


func _process(_delta):
	# If we've just now eaten enough guys, win!
	if num_guys_eaten >= num_guys_to_eat and full == false:
		full = true
		feed_me_label.hide()
		num_of_guys_label.hide()
		guys_label.hide()
		win_text.show()
		normal_frog_sprite.hide()
		happy_frog_sprite.show()



func _on_body_entered(body):
	# If the body we collided with is a LittleGuys, eat him
	if body.is_in_group("LittleGuys") and full == false:
		num_guys_eaten += 1
		body.queue_free()
		# Update the label in the speech bubble
		num_of_guys_label.text = str(num_guys_to_eat - num_guys_eaten)
