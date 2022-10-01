extends AnimatedSprite2D

var lifespan = 36
var lifetime = 0

func _ready():
	frame = 0
	playing = true
	speed_scale = 10

func _process(delta):
	if lifetime >= lifespan:
		queue_free()
	lifetime += 1

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		print("exploded yourself")
	if body.is_in_group("enemy"):
		print("exploded enemy")
