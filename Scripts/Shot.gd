extends Node2D

var lifetime := 0
var lifespan := 10

func _physics_process(_delta):
	if lifetime >= lifespan:
		queue_free()
	lifetime += 1
	
