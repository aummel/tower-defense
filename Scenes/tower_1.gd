extends StaticBody2D

# Preloads
var Bullet = preload("res://Scenes/bullet1.tscn")
var bulletDamage = 5

# Variables
var pathName
var currTargets = []
var curr
var reload = 0
var range = 150
var startShooting = false

# Node caches
@onready var bulletContainer = $BulletContainer
@onready var upgradePanel = $Upgrade/Upgrade
@onready var aimNode = $Aim
@onready var timer = $Upgrade/ProgressBar/Timer
@onready var prog = $Upgrade/ProgressBar


func _process(delta):
	prog.global_position = self.position + Vector2(-30,-45)
	if is_instance_valid(curr):
		self.look_at(curr.global_position)
		if timer.is_stopped():
			timer.start()
	else:
		# Clear bullets
		for i in range(bulletContainer.get_child_count()):
			bulletContainer.get_child(i).queue_free()
	update_powers()

func Shoot():
	var tempBullet = Bullet.instantiate()
	tempBullet.pathName = pathName
	tempBullet.bulletDamage = bulletDamage
	bulletContainer.add_child(tempBullet)
	tempBullet.global_position = aimNode.global_position
	
func _on_tower_body_entered(body):
	$Upgrade/ProgressBar/Timer.paused = false
	if "enemy" in body.name:
		var tempArray = []
		currTargets = get_node("Tower").get_overlapping_bodies()
		for i in currTargets:
			if "enemy" in i.name:
				tempArray.append(i)

		var currTarget = null
		for i in tempArray:
			if currTarget == null:
				currTarget = i.get_node("../")
			else:
				if i.get_parent().get_progress() > currTarget.get_progress():
					currTarget = i.get_node("../")

		curr = currTarget
		pathName = currTarget.get_parent().name
		


func _on_tower_body_exited(body):
	currTargets = get_node("Tower").get_overlapping_bodies()


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
			upg.global_position = self.global_position + Vector2(-80, 25)
		else:
			print("Upgrade/Upgrade node not found!")


func _on_timer_timeout():
	if curr != null:
		Shoot()
	else: $Upgrade/ProgressBar/Timer.paused = true
	


func _on_range_pressed():
	if Game.gold >= 10:
		if range <= 300:
			range += 25
			Game.gold -= 10
		else:
			range = 300


func _on_attack_speed_pressed():
	if Game.gold >= 5:
		if reload <= 1.8:
			reload +=0.1
			Game.gold -= 5
		if timer.wait_time < 0.8:
			timer.wait_time =0.8
		timer.wait_time = 2.5 - reload


func _on_power_pressed():
	if Game.gold >= 15:
		if bulletDamage >= 15:
			bulletDamage = 15
		else:
			bulletDamage += 5
			Game.gold -= 15
		 

func update_powers():
	get_node("Upgrade/Upgrade/HBoxContainer/Range/Label").text = str(range)
	get_node("Upgrade/Upgrade/HBoxContainer/Attack Speed/Label").text = str(2.5 - reload)
	get_node("Upgrade/Upgrade/HBoxContainer/Power/Label").text = str(bulletDamage)
	get_node("Tower/CollisionShape2D2").shape.radius= range


func _on_range_mouse_entered():
	get_node("Tower/CollisionShape2D2").show()


func _on_range_mouse_exited():
	get_node("Tower/CollisionShape2D2").hide()
