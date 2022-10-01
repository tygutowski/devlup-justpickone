extends CharacterBody2D

class_name Projectile

var speed: float = 50.0
var direction: Vector2 = Vector2(0,0);
var bounces: int = 2

func _physics_process(_delta: float) -> void:
	var coll = move_and_collide(direction * speed * _delta)
	self.rotate(0.5)

	if coll != null:
		direction = direction.bounce(coll.get_normal())
		bounces -= 1
		if bounces < 0:
			self.queue_free()

