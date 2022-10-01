extends CharacterBody2D

class_name Projectile

var speed: float = 2.0

func _physics_process(_delta: float) -> void:
	position += transform.x * speed
#	move_and_collide(Vector2.RIGHT, speed)

