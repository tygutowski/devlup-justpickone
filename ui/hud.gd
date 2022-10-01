extends CanvasLayer

func _ready():
	visible = true

func _unhandled_input(event):
	if Input.is_action_just_pressed("escape"):
		visible = !visible
