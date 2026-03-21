extends StaticBody2D
var reload = 0
@onready var time = $Upgrade/ProgressBar/Timer
@onready var prog = $Upgrade/ProgressBar
@onready var upgradePanel = $Upgrade/Upgrade

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_powers()
	prog.global_position = self.position + Vector2(-78, -92)


func _on_timer_timeout():
	Game.health += 1


func _on_heal_speed_pressed():
	if Game.gold >= 10:
		if reload <= 15:
			reload +=1
			Game.gold -= 10
		if time.wait_time < 15:
			time.wait_time = 15
		time.wait_time = 30 - reload
		
func update_powers():
	get_node("Upgrade/Upgrade/Label").text = str(30 - reload)


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:

		var towerPath = get_tree().get_root().get_node("Node2D/towers")

		# Hide other towers' upgrade panels
		for child in towerPath.get_children():
			if child == self:
				continue
			if child.has_node("Upgrade/Upgrade"):
				var otherUpg = child.get_node("Upgrade/Upgrade")
				otherUpg.visible = false
			if child.has_node("Upgrade/ProgressBar"):
				var otherBAr = child.get_node("Upgrade/ProgressBar")
				otherBAr.visible = false

		# Toggle this tower's upgrade panel
		if has_node("Upgrade/Upgrade"):
			var upg = get_node("Upgrade/Upgrade")
			var lab = get_node("Upgrade/ProgressBar")
			upg.visible = !upg.visible
			lab.visible = !lab.visible

		

			# Position panel relative to tower
			upg.global_position = self.global_position + Vector2(-114, 57)
		else:
			print("Upgrade/Upgrade node not found!")
