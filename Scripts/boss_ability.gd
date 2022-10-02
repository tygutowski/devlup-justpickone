class_name BossAbility
extends Node2D

@export var effect_duration : float
@onready var duration_timer : Timer = $DurationTimer

func _ready():
	duration_timer.connect("timeout", _on_ability_timeout)
	duration_timer.wait_time = effect_duration


func trigger_ability(boss: Boss):
	pass


func _on_ability_timeout():
	pass

