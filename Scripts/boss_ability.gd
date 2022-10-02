class_name BossAbility
extends Node2D

@onready var duration_timer : Timer = $DurationTimer

func _ready():
	$DurationTimer.connect("timeout", _on_ability_timeout)


func trigger_ability(boss: Enemy):
	pass


func _on_ability_timeout():
	pass

