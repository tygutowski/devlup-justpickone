extends Node2D

func _on_area_2d_body_entered(body):
	print("Stairs collided")
	if body.is_in_group("player"):
		print("with player")
		LevelGenerator.level += 1
		get_tree().change_scene_to_file("res://Scenes/Game.tscn")
	
	# If the stairs were instanced inside a wall, move it.
	if body.is_in_group("tilemap"):
		print("with tilemap")
		var new_position := Vector2i(
		randi_range(25, 850),
		randi_range(25, 850)
		)
		self.global_position = new_position
