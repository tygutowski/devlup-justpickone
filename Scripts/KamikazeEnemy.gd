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
	
	is_target_in_range = true
	is_chasing_player = false # So it stops walking
	
	$AnimationPlayer.play("exploded") # Warn player it's about to explode.
	
	$ExplosionTimer.start()
	await $ExplosionTimer.timeout
	# Enemy has now exploded.
	$ExplosionArea.monitoring = false # Disabling the [ExplosionArea] so player doesn't trigger explosion twice.
	$Explosion.visible = true
	$Sprite2d.visible = false
	($Explosion as AnimatedSprite2D).play("exploded") # first half of explosion
	
	if is_target_in_range:
		(body as Player).takeDamage(explosion_damage)
	await $Explosion.animation_finished
	
	$Explosion.visible = false # second part of explosion, dusty part, deals no damage
	$ExplosionArea/CollisionShape2d.disabled = true
	$Explosion2.visible = true
	($Explosion2 as AnimatedSprite2D).play("exploded")
	await $Explosion2.animation_finished
	queue_free()



func _on_explosion_area_body_exited(body):
	if body is Player:
		is_target_in_range = false
