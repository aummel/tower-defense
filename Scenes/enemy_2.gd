extends CharacterBody2D

@export var speed = 75
var Health = 75
@warning_ignore("unused_signal")
signal died  # declare the signal

func _ready():
	pass

func _process(delta):
	# Move along the path
	get_parent().set_progress(get_parent().get_progress() + speed * delta)

	# Reached end of path
	if get_parent().get_progress_ratio() >= 1:
		Game.health -= 30
		queue_free()
		

	# Enemy killed
	if Health <= 0:
		emit_signal("died")  # emit the died signal BEFORE freeing
		get_parent().get_parent().queue_free()  # original behavior
		queue_free()  # remove this node
