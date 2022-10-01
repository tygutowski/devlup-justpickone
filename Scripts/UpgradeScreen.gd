extends CanvasLayer

# button num mouse inside
var b1mi = false
var b2mi = false
var b3mi = false
var b4mi = false

@onready var upgrades = get_tree().get_nodes_in_group("player")[0].upgrades

var new_item

func delete(item_slot):
	upgrades[item_slot] = new_item
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
