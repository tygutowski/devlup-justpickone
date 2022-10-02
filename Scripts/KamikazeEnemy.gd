extends Enemy

# $ExplosionTimer is how long it takes the enemy to explode.

@export var explosion_damage := 75
@export var delay_before_explosion := 0.6
var is_target_in_range := false # Using this to track whether player has escaped the AoE


func _ready() -> void:
	walk_speed = 40
	$CollisionShape2d.disabled = false
	$Hitbox/CollisionShape2d.disabled = false
	$ExplosionTimer.wait_time = delay_before_explosion
	$Explosion.visible = false
	$Explosion2.visible = false

func _on_body_entered_explosion_radius(body):
	if body is Player == false:
		return
	
	is_chasing_player = false # Stopping enemy from moving.
	is_target_in_range = true
	
	$AnimationPlayer.play("about_to_explode")
	await $AnimationPlayer.animation_finished
	
	# Enemy is exploding now.
	$Explosion.visible = true
	$Explosion.play("exploded")
	$FX/ExplodedFX.play()
	$Sprite2d.hide()
	if is_target_in_range:
		(body as Player).get_node("ShakeCamera2D").medium_shake()
		(body as Player).takeDamage(explosion_damage)
	for overlappingBody in ($ExplosionArea as Area2D).get_overlapping_bodies():
		if overlappingBody is Enemy:
			overlappingBody.takeDamage(explosion_damage)
	$ExplosionArea.monitoring = false # So player doesn't retrigger the explosion
	$CollisionShape2d.disabled = true # So player doesn't walk into it after the explosion.
	
	await $Explosion.animation_finished
	# Smoke
	$Explosion2.visible = true
	$Explosion2.play("exploded")
	await $Explosion2.animation_finished
	queue_free()


func _on_explosion_area_body_exited(body):
	# player leave bomba area
	if body is Player and body.is_in_group("player"):
		is_target_in_range = false
