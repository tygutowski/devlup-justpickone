extends Node2D

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		LevelGenerator.level += 1
		get_tree().change_scene_to_file("res://Scenes/Game.tscn")
	if body.is_in_group("tilemap"):
		get_tree().get_first_node_in_group("game").spawn_stairs()
		queue_free()
