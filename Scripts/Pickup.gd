extends Area2D

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		(body as Player).upgrade()
		queue_free()
	if body.is_in_group("tilemap"):
		get_tree().get_first_node_in_group("game").spawn_upgrade(1)
		queue_free()
