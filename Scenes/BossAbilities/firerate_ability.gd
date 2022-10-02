extends BossAbility

@export var seconds_to_shoot := 1.0

var the_boss : Boss

func trigger_ability(boss : Boss) -> void:
	the_boss = boss
	duration_timer.one_shot = false
	duration_timer.wait_time = seconds_to_shoot
	duration_timer.start()


func _on_ability_timeout():
	the_boss.perform_attack()
