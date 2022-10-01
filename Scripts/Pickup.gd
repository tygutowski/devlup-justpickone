extends Area2D

@onready var player = get_tree().get_nodes_in_group("player")[0]

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player.upgrade()
	queue_free()
