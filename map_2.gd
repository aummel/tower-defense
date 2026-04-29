extends Node2D

var kills = 0
var enemy2_connected = false
func _ready():
	Game.gold = 100
	Game.health = 5

func _process(delta):
	if not enemy2_connected:
		var enemy2 = get_tree().get_current_scene().get_node_or_null("PathSpawner/PathNode/enemy2")
		if enemy2:
			enemy2.connect("died", Callable(self, "_on_enemy2_died"))
			enemy2_connected = true

	# Lose condition
	if Game.health <= 0:
		var evil = get_tree().get_current_scene().get_node_or_null("PathSpawner")
		if evil:
			evil.queue_free()
		$"You Lose".show()
		$Redo.show()
		$"Give Up".show()
		$Return.show()
		$UI.hide()

func _on_enemy2_died():
	# Increment kills and trigger win UI
	kills += 1
	var evil = get_tree().get_current_scene().get_node_or_null("PathSpawner")
	if evil:
		evil.queue_free()
	$"You Win".show()
	$Return.show()
	$Redo.show()
	$"Give Up".show()
	$PathSpawner/Timer2.stop()

func _on_redo_pressed():
	get_tree().reload_current_scene()
	
func _on_give_up_pressed():
	get_tree().quit()

func _on_return_pressed():
	get_tree().change_scene_to_file("res://Scenes/ATGtitle.tscn")
