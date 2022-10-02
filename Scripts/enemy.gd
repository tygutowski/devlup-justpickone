class_name Enemy
extends CharacterBody2D


## How much damage will the player take upon touching it.
@export var contact_damage := 25 
@export var health := 50  
@export var walk_speed := 40
@onready var default_speed : int = walk_speed # DO NOT MODIFY THIS VARIABLE. This in case something movies walk_speed. 

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2d

var is_chasing_player := true

func _ready():
	walk_speed = 40
	$CollisionShape2d.disabled = false
	$Hitbox/CollisionShape2d.disabled = false
	_update_pathfinding()

func _physics_process(delta):
	if nav_agent.is_navigation_finished() or is_chasing_player == false:
		return
	
	var direction := global_position.direction_to(nav_agent.get_next_location())
	var desired_velocity := direction * 40.0
	velocity = (desired_velocity - velocity) * delta * walk_speed
	
	move_and_slide()
 

func takeDamage(damage_amount := 25):
	health -= damage_amount
	if health <= 0:
		health = 0
		$AnimationPlayer.play("died") # Animation takes care of queue_free and what not.
		return
	
	$AnimationPlayer.play("hurt")

func _on_hitbox_body_entered(body):
	if body.is_in_group("player") == false or body.has_method("takeDamage") == false:
		return
	
	body.takeDamage(contact_damage)
	
	# Disabling enemy movement momenetarily, so they don't pile up on player.
	is_chasing_player = false
	await get_tree().create_timer(0.6).timeout
	is_chasing_player = true

func _update_pathfinding():
	if player == null:
		return
	nav_agent.set_target_location(player.global_position)
