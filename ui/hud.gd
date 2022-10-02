extends CanvasLayer

func _ready():
	visible = true

func _process(_delta: float) -> void:
	visible = !get_tree().paused
