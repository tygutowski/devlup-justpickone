extends AnimatedSprite2D

@export var explosion_damage := 10

var lifespan := 36
var lifetime := 0

func _ready():
	rotation = randf_range(0,2)
	frame = 0
	playing = true
	speed_scale = 10

func _process(delta):
	if lifetime >= lifespan:
		queue_free()
	lifetime += 1

func _on_area_2d_body_entered(body):
	if body.has_method("takeDamage"):
		body.takeDamage(explosion_damage)
