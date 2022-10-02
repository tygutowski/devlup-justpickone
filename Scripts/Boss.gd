extends Enemy

signal just_died

enum States {
	Idle,
	Walking,
	Attacking,
}

enum Actions {
	Chase,
	Shoot,
	SpawnEnemies,
}

@onready var projectile = preload("res://Scenes/Projectile.tscn")

var currentState := States.Idle

var abilities : Array
var bullet_bounces : int = 1

func _ready():
	super._ready()
	abilities = $Abilities.get_children()

func _physics_process(delta):
	if currentState == States.Idle:
		return
	
	print("Current state: ", currentState)
	if currentState == States.Attacking:
		is_chasing_player = false
		perform_attack() # Shoot bullet at player
	
	if currentState == States.Walking:
		is_chasing_player = true
	
	super._physics_process(delta)

func perform_attack():
	print("=== PERFORMING ATTACK ===")
	
	var projectile_instance : Projectile = projectile.instantiate()
	
	projectile_instance.look_at(player.global_position)
	var player_direction := self.global_position.direction_to(player.global_position)
	projectile_instance.direction = player_direction
	projectile_instance.bounces = bullet_bounces
	projectile_instance.speed = 50
	# Setting it to be where the boss is, but adding an offset so that it doesn't get stuck inside the boss.
	projectile_instance.global_position = self.global_position + (player_direction * 20)
	get_tree().root.add_child(projectile_instance)
	
	currentState = States.Walking

func _on_use_ability_timer_timeout():
	if abilities.size() == 0:
		print("NO ABILITIES ASSIGNED TO BOSS")
		return
	
	var i := randf_range(0, abilities.size() - 1)
	var abilityToUse : BossAbility = abilities[i]
	abilityToUse.trigger_ability(self)


func takeDamage(damage_amount : int = 25):
	if currentState == States.Idle:
		currentState = States.Walking
		activate_boss()
	
	emit_signal("just_died")
	super.takeDamage()

func activate_boss():
	player.is_fighting_boss = true
	$UseAbilityTimer.start()
	$WhatNextTimer.start()

func _on_what_next_timer_timeout():
	print("WHAT NEXT?")
	# Whether to shoot or keep chasing the player
	currentState = States.Attacking if randi_range(0, 1) == 1 else States.Walking
