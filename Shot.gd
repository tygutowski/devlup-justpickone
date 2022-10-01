extends Node2D

var lifetime = 0
var lifespan = 10

func _process(delta):
	if lifetime >= lifespan:
		queue_free()
	lifetime += 1
	
