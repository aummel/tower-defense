extends CharacterBody2D

var target
var Speed = 500
var pathName = ""
var bulletDamage

func _physics_process(delta):
	var pathSpawnerNode = get_tree().get_root().get_node_or_null("Node2D/PathSpawner")
	if pathSpawnerNode == null:
		queue_free()
		return

	for child in pathSpawnerNode.get_children():
		if child.name == pathName:
			target = child.get_child(0).get_child(0).global_position

	if target == null:
		queue_free()
	else:
		velocity = global_position.direction_to(target) * Speed
		look_at(target)
		move_and_slide()

func _on_area_2d_body_entered(body):
	if "enemy" in body.name:
		body.Health -= bulletDamage
		queue_free()
