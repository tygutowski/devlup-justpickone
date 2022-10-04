extends Area2D

func _on_area_2d_body_entered(body):
	print("Pickup collided")
	if body.is_in_group("player"):
		print("with player")
		body.upgrade()
	
	if body.is_in_group("tilemap"):
		print("with tilemap")
		get_tree().get_first_node_in_group("game").spawn_upgrade(1)
	
	queue_free()
