extends CanvasLayer

# button num mouse inside
var b1mi = false
var b2mi = false
var b3mi = false
var b4mi = false

@onready var upgrades = get_tree().get_nodes_in_group("player")[0].upgrades

var upgr

func generate_new_item():
	var random_number = randi_range(0,11)
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
	upgrades.append(upgr)
	upgr.player = get_tree().get_nodes_in_group("player")[0]

func _ready():
	generate_new_item()
	#update_sprites()

func delete(item_slot):
	upgr.pickup()
	upgrades[item_slot].drop()
	upgrades[item_slot] = upgr
	get_tree().get_nodes_in_group("game")[0].set_physics_process(true)
	get_tree().get_nodes_in_group("player")[0].exit_menu()
	queue_free()

func _input(event):
	if event.is_action_pressed("shoot"):
		if b1mi:
			# swap upgrade for 1st slot
			delete(0)
		if b2mi:
			# swap upgrade for 1st slot
			delete(1)
		if b3mi:
			# swap upgrade for 1st slot
			delete(2)
		if b4mi:
			# swap upgrade for 1st slot
			delete(3)

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
