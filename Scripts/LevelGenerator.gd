extends Node

var level := 1

func generate_level():
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")
	level += 1
