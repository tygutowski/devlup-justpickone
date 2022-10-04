extends BossAbility

@export var damage_multiplier := 1.25

func trigger_ability(boss : Boss) -> void:
	#print("DAMAGE ABILITY")
	var original_damage_value := boss.contact_damage
	boss.contact_damage *= damage_multiplier
	duration_timer.start()
	await duration_timer.timeout
	boss.contact_damage = original_damage_value

func _on_ability_timeout():
	pass
