extends Control

@export var nextScene: PackedScene



func _on_play_pressed():
	get_tree().change_scene_to_packed(nextScene)

func _on_quit_pressed():
	get_tree().quit()
