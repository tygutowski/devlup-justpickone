class_name Player
extends CharacterBody2D

@export var damage := 10
var speed := 125.0
var is_fighting_boss := false
@export var health := 100 : set = update_health
func update_health(value: int):
	health = value
	($HUD/UI/ProgressBar as ProgressBar).value = health

var shot_count := 1
var pierce_count := 1
@onready var max_health := health

@export var SPEED = 100.0

@onready var shot := preload("res://Scenes/Shot.tscn")
var walking_direction := Vector2.ZERO
var facing_direction := Vector2.ZERO

var reload_timer := 60
var reload_time := 0

var vulnerable := true # Whether Player cana take damage or not.

@onready var game := get_tree().get_first_node_in_group("game")


var ammo_max := 6
var ammo := ammo_max : set = update_ammo
func update_ammo(value : int):
	ammo = value
	$HUD/UI/MagSize.text = "%s/%s" % [ammo, ammo_max]

var currently_reloading := false

var shot_timer := 6
var shot_time := shot_timer

var in_menu := false



func generate_upgrades():
	for i in range(4):
		var random_number := randi_range(1,9)
		var dir = load("res://Resources/Upgrade.tres")
		var upgr = dir.duplicate()
		match random_number:
			1:
				upgr.reload_up = true
			2:
				upgr.speed_up = true
			3:
				upgr.piercing_once = true
			4:
				upgr.double_shot = true
			5:
				upgr.explosive_shot = true
			6:
				upgr.higher_damage = true
			7:
				upgr.reload_halved = true
			8:
				upgr.shot_speed_up = true
			9:
				upgr.ammo_up_three = true
				
		LevelGenerator.upgrades.append(upgr)
		upgr.player = self
		upgr.pickup()

func _ready():
	for upgrade in LevelGenerator.upgrades:
		upgrade.player = self
		upgrade.pickup()
	#generate_upgrades()
	set_animation("idle_or_walking", 0)
	set_animation("direction", 1)
	$HUD/UI/MagSize.text = "%s/%s" % [ammo, ammo_max]
	$HUD/UI/ProgressBar.value = health
	$Music.playing = true
	$BossMusic.playing = false

func _physics_process(_delta):
	if in_menu:
		return
	
	if currently_reloading:
		if reload_time > reload_timer:
			currently_reloading = false
			reload_time = 0
			ammo = ammo_max
		reload_time += 1
	else:
		walking_direction = Vector2(
			Input.get_axis("left", "right"),
			Input.get_axis("up", "down"),
		).normalized()
		
		velocity = walking_direction * speed
		move_and_slide()
		
		if walking_direction != Vector2.ZERO:
			facing_direction = walking_direction
		
		if walking_direction == Vector2.ZERO:
			set_animation("idle_or_walking", 0)
		else:
			set_animation("idle_or_walking", 1)
			if facing_direction.x < 0: # Left
				set_animation("direction", 2)
			elif facing_direction.x > 0: # Right
				set_animation("direction", 3)
			elif facing_direction.y > 0: # Down
				set_animation("direction", 1)
			elif facing_direction.y < 0: # Up
				set_animation("direction", 0)
		
		if Input.is_action_just_pressed("shoot") && shot_time >= shot_timer:
			if ammo > 0:
				shoot()
				shot_time = 0
				ammo -= 1
			else:
				$HUD.show_reload_tooltip()
				$FX/GunJammedFX.play()
		
		if Input.is_action_just_pressed("reload") && ammo != ammo_max:
			$FX/ReloadFX.play()
			currently_reloading = true
		
		if Input.is_action_just_pressed("new_map"):
			LevelGenerator.level += 2
			get_tree().change_scene_to_file("res://Scenes/Game.tscn")
		
		shot_time += 1

func set_animation(animation_name: String, value: int):
	if animation_name == "direction":
		get_node("AnimationTree").set("parameters/direction_walking/current", value)
		get_node("AnimationTree").set("parameters/direction_idle/current", value)
	else:
		get_node("AnimationTree").set("parameters/" + animation_name + "/current", value)

func shoot() -> void:
	# make a new shot
	for x in range(shot_count):
		var discrepancy := Vector2.ZERO
		if x != 0:
			discrepancy = Vector2(randi_range(0,25), randi_range(0,25))
		var hit_list := []
		for i in range(pierce_count):
			var ray : Node2D = shot.instantiate()
			var raycast : RayCast2D = ray.get_node("RayCast2d")
			for object in hit_list:
				raycast.add_exception(object)
			game.add_child(ray)
			# set position to player
			raycast.global_position = global_position
			# set target to mouse
			raycast.target_position = (get_local_mouse_position() + discrepancy).normalized() * 100000
			raycast.enabled = true
			raycast.force_raycast_update()
			ray.get_node("Line2d").add_point(raycast.global_position)
			var pos := raycast.get_collision_point()
			if pos == Vector2.ZERO:
				pos = raycast.target_position
			
			ray.get_node("Line2d").add_point(pos)
			$FX/ShootFX.play()
			
			var hitNode := raycast.get_collider()
			if hitNode != null:
				if hitNode.is_in_group("enemy") || hitNode is Enemy:
					hitNode.takeDamage(damage)
					hit_list.append(hitNode)
			
			var expl : Node2D = null
			for u in LevelGenerator.upgrades:
				if u.explosive_shot:
					if expl == null:
						expl = load("res://Scenes/Explosion.tscn").instantiate()
						expl.global_position = raycast.get_collision_point()
						game.add_child(expl)
					expl.explosion_damage += 5

func upgrade() -> void:
	in_menu = true
	var upgrade_menu : CanvasLayer = load("res://Scenes/UpgradeScreen.tscn").instantiate()
	add_child(upgrade_menu)

func exit_menu() -> void:
	in_menu = false
	shot_time = 0

func takeDamage(damage_amount : int) -> void:
	if vulnerable == false:
		return
	
	health -= damage_amount
	#print("Player health: ", health)
	if health <= 0:
		health = 0
		$AnimationPlayer.play("died")
		await $AnimationPlayer.animation_finished
		get_tree().reload_current_scene()
		return
	
	vulnerable = false
	$AnimationPlayer.play("hurt")
	await $AnimationPlayer.animation_finished
	vulnerable = true
