extends BossAbility

@export var explosion_damage := 60

func _ready():
	$Explosion.hide()
	$Explosion2.hide()

func trigger_ability(boss : Boss) -> void:
	boss.is_chasing_player = false
	var anim_player := boss.get_node("AnimationPlayer")
	anim_player.play("about_to_explode")
	await anim_player.animation_finished
	# Explosion has occurred.
	$Explosion.show()
	$Explosion.frame = 0
	$Explosion.play("exploded")
	var bodies_inside_explosion := ($ExplosionArea as Area2D).get_overlapping_bodies()
	var player : Player = null
	for body in bodies_inside_explosion:
		if body is Player:
			player = body
	if player != null:
		player.takeDamage(explosion_damage)
	await $Explosion.animation_finished
	$Explosion.hide()
	
	$ExplosionArea.monitoring = false	
	
	$Explosion2.show()
	$Explosion2.frame = 0
	($Explosion2 as AnimatedSprite2D).play("exploded")
	await $Explosion2.animation_finished
	$Explosion2.hide()
	
	boss.is_chasing_player = true
	$ExplosionArea.monitoring = true

func _on_ability_timeout():
	pass
