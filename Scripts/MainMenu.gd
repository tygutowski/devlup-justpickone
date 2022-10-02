extends Control

@export var path_to_next_scene : String

func _on_play_pressed():
	($FX/ClickedFX as AudioStreamPlayer).play()
	await $FX/ClickedFX.finished
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_play_mouse_entered():
	$FX/HoverOverButtonFX.play()

func _on_quit_mouse_entered():
	$FX/HoverOverButtonFX.play()
