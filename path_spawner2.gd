extends Node2D

@onready var path = preload("res://Stage2.tscn")
@onready var BOSSpath = preload("res://stage_2BOSS.tscn")

var time := 0
var timer2_started := false
var spawned_path: Node = null  

func _ready() -> void:
	pass # Replace with function body.



func _on_timer_timeout() -> void:
	spawned_path = path.instantiate()
	add_child(spawned_path)

	time += 1
	print(time)

	$Timer.wait_time = max($Timer.wait_time - 0.08, 0.3)
	$Timer.start()

func _process(delta):
	if time >= 15 and not timer2_started:
		$Timer.stop()

		if spawned_path and spawned_path.is_inside_tree():
			spawned_path.queue_free()

		timer2_started = true
		$Timer2.start()

func _on_timer_2_timeout():
	print("its working")
	var newBOSSpath = BOSSpath.instantiate()
	add_child(newBOSSpath)

	# Recursively find enemy2 inside newBOSSpath
	var enemy2 = _find_enemy2(newBOSSpath)
	if enemy2:
		enemy2.connect("died", Callable(get_tree().get_current_scene(), "_on_enemy2_died"))
		print("enemy2 signal connected!")

# Helper function to find enemy2 recursively
func _find_enemy2(node):
	if node.name.begins_with("enemy2"):
		return node
	for child in node.get_children():
		var result = _find_enemy2(child)
		if result:
			return result
	return null
