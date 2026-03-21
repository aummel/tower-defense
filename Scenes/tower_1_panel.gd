extends Panel

@onready var tower = preload("res://Scenes/tower_1.tscn")
var currTile
var preview_tower: Node = null

func _on_gui_input(event):
	if Game.gold < 25:
		return  # not enough gold, ignore input

	# LEFT MOUSE BUTTON DOWN — spawn preview tower
	if event is InputEventMouseButton and event.button_mask == 1:
		print("left down")
		preview_tower = tower.instantiate()
		add_child(preview_tower)
		preview_tower.process_mode = Node.PROCESS_MODE_DISABLED
		preview_tower.scale = Vector2(0.34, 0.34)

	# LEFT MOUSE BUTTON DRAG — move preview tower
	elif event is InputEventMouseMotion and event.button_mask == 1:
		if preview_tower:
			preview_tower.global_position = event.global_position

			# Tile map logic
			var mapPath = get_tree().get_root().get_node("Node2D/TileMap")
			var tile = mapPath.local_to_map(get_global_mouse_position())
			currTile = mapPath.get_cell_atlas_coords(0, tile, false)

			# TowerDetector logic
			var targets = []
			if preview_tower.has_node("TowerDetector"):
				targets = preview_tower.get_node("TowerDetector").get_overlapping_bodies()

			# Update Area color
			if currTile == Vector2i(7, 1):
				if targets.size() > 0:
					if preview_tower.has_node("Area"):
						preview_tower.get_node("Area").modulate = Color(1, 0, 0, 0.3)
				else:
					if preview_tower.has_node("Area"):
						preview_tower.get_node("Area").modulate = Color(0, 1, 0, 0.3)
			else:
				if preview_tower.has_node("Area"):
					preview_tower.get_node("Area").modulate = Color(1, 0, 0, 0.3)

	# LEFT MOUSE BUTTON UP — place tower
	elif event is InputEventMouseButton and event.button_mask == 0:
		print("left up")
		if preview_tower:
			# Remove preview if outside map
			if event.global_position.x >= 800:
				preview_tower.queue_free()
				preview_tower = null
				return

			# Remove the preview tower (we’ll place a real one)
			preview_tower.queue_free()
			preview_tower = null

			# Only place tower if on correct tile
			if currTile == Vector2i(7, 1):
				var path = get_tree().get_root().get_node("Node2D/towers")
				var newTower = tower.instantiate()
				path.add_child(newTower)
				newTower.global_position = event.global_position
				if newTower.has_node("Area"):
					newTower.get_node("Area").hide()
				Game.gold -= 25

	# Fallback — remove preview if something unexpected
	else:
		if preview_tower:
			preview_tower.queue_free()
			preview_tower = null
