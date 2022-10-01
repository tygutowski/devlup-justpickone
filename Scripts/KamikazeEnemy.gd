extends Enemy

@export var explosion_damage := 75
@export var delay_before_explosion := 0.6

var _target_in_range := false

func _ready() -> void:
	$ExplosionTimer.wait_time = delay_before_explosion

func _on_body_entered_explosion_radius(body):
	if body is Player == null:
		return
	
	is_chasing_player = false # So it stops walking
	
	_target_in_range = true
	$ExplosionTimer.start()
	await $ExplosionTimer.timeout
	if !_target_in_range:
		return
	
	(body as Player).takeDamage(explosion_damage)
	
	$AnimationPlayer.play("exploded") # The animation calls queue_free()



func _on_explosion_area_body_exited(body):
	if body is Player:
		_target_in_range = false
