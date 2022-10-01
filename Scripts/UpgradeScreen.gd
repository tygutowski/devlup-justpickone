extends CanvasLayer

# button num mouse inside
var b1mi = false
var b2mi = false
var b3mi = false
var b4mi = false

@onready var upgrades = get_tree().get_nodes_in_group("player")[0].upgrades

var item1
var item2
var item3

var upgr

func generate_new_item():
	var random_number = randi_range(1,11)
	var dir = load("res://Resources/Upgrade.tres")
	upgr = dir.duplicate()
	match random_number:
		1:
			upgr.reload_up = true
		2:
			upgr.speed_up = true
		3:
			upgr.richochet_twice = true
		4:
			upgr.double_shot = true
		5:
			upgr.explosive_shot = true
		6:
			upgr.exploding_kills = true
		7:
			upgr.reload_halved = true
		8:
			upgr.shot_speed_up = true
		9:
			upgr.ammo_up_three = true
		10:
			upgr.higher_damage = true
		11:
			upgr.piercing_once = true
	return upgr
func _ready():
	item1 = generate_new_item()
	item2 = generate_new_item()
	item3 = generate_new_item()
	$PanelContainer/MarginContainer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer3/Label.text = item1.get_name()
	$PanelContainer/MarginContainer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer4/Label.text = item2.get_name()
	$PanelContainer/MarginContainer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer5/Label.text = item3.get_name()
	
	$PanelContainer/MarginContainer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer3/MarginContainer/TextureRect.texture = load(item1.get_sprite())
	$PanelContainer/MarginContainer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer4/MarginContainer2/TextureRect.texture = load(item2.get_sprite())
	$PanelContainer/MarginContainer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer5/MarginContainer2/TextureRect.texture = load(item3.get_sprite())

	
func pick_item(item_slot):
	var new_item
	if item_slot == 0:
		new_item = item1
		give_boss(item2)
		give_boss(item3)
	elif item_slot == 1:
		new_item = item2
		give_boss(item3)
		give_boss(item1)
	elif item_slot == 2:
		new_item = item3
		give_boss(item2)
		give_boss(item1)
	# add to upgrades list
	upgrades.append(new_item)
	new_item.player = get_tree().get_nodes_in_group("player")[0]
	
	# give player stats
	new_item.pickup()
	get_tree().get_nodes_in_group("game")[0].set_physics_process(true)
	get_tree().get_nodes_in_group("player")[0].exit_menu()
	queue_free()

func _input(event):
	if event.is_action_pressed("shoot"):
		if b1mi:
			# swap upgrade for 1st slot
			pick_item(0)
		if b2mi:
			# swap upgrade for 1st slot
			pick_item(1)
		if b3mi:
			# swap upgrade for 1st slot
			pick_item(2)
		if b4mi:
			# swap upgrade for 1st slot
			pick_item(3)

func _on_h_box_container_3_mouse_entered():
	b1mi = true

func _on_h_box_container_3_mouse_exited():
	b1mi = false

func _on_h_box_container_4_mouse_entered():
	b2mi = true


func _on_h_box_container_4_mouse_exited():
	b2mi = false


func _on_h_box_container_5_mouse_entered():
	b3mi = true


func _on_h_box_container_5_mouse_exited():
	b3mi = false


func _on_h_box_container_6_mouse_entered():
	b4mi = true


func _on_h_box_container_6_mouse_exited():
	b4mi = false

func give_boss(item):
	print("Giving boss: " + str(item.get_name()))
