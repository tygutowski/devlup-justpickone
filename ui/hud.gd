extends CanvasLayer

func _ready():
	visible = true
	$UI/PressRtoReload.hide()

func _process(_delta: float) -> void:
	visible = !get_tree().paused

func show_reload_tooltip():
	$ShowTooltipTimer.start()
	$UI/PressRtoReload.show()
	await $ShowTooltipTimer.timeout
	$UI/PressRtoReload.hide()
