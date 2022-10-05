extends BossAbility

@export var speed_multiplier := 1.25

func trigger_ability(boss : Boss) -> void:
	#print("SPEED ABILITY")
	boss.walk_speed *= speed_multiplier
	duration_timer.start()
	await duration_timer.timeout
	boss.walk_speed = boss.default_speed

func _on_ability_timeout():
	pass
