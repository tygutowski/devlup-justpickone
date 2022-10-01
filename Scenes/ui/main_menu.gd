extends Control

@export var nextScene: PackedScene



func _on_play_pressed():
	($FX/ClickedFX as AudioStreamPlayer).play()
	await $FX/ClickedFX.finished
	get_tree().change_scene_to_packed(nextScene)

func _on_quit_pressed():
	get_tree().quit()


func _on_play_mouse_entered():
	$FX/HoverOverButtonFX.play()


func _on_quit_mouse_entered():
	$FX/HoverOverButtonFX.play()
