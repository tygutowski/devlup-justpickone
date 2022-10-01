extends CanvasLayer

@export var main_menu : PackedScene

func _ready():
	visible = false

func _unhandled_input(event):
	if Input.is_action_just_pressed("escape"):
		get_tree().paused = !get_tree().paused
		visible = !visible

func _on_resume_pressed():
	get_tree().paused = false
	visible = !visible

func _on_main_menu_pressed():
	get_tree().change_scene_to_packed(main_menu)
