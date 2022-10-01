class_name Player
extends CharacterBody2D


var damage = 10
var speed = 100.0


@export var health = 100
@export var SPEED = 100.0

var shot = preload("res://Scenes/Shot.tscn")
var walking_direction = Vector2.ZERO
var facing_direction = Vector2.ZERO


var reload_timer = 60
var reload_time = 0

var vulnerable := true # Whether Player cana take damage or not.

@onready var game = get_tree().get_first_node_in_group("game")


var ammo_max = 6
var ammo = ammo_max

var currently_reloading = false

var shot_timer = 6
var shot_time = shot_timer

var in_menu = false

@export var upgrades:Array = []


func generate_upgrades():
	for i in range(4):
		var random_number = randi_range(1,11)
		var dir = load("res://Resources/Upgrade.tres")
		var upgr = dir.duplicate()
		match random_number:
			1:
				upgr.reload_up = true
			2:
				upgr.speed_up = true
			3:
				upgr.richochet_twice = true
			4:
				upgr.double_shot = true
			5:
				upgr.explosive_shot = true
			6:
				upgr.exploding_kills = true
			7:
				upgr.reload_halved = true
			8:
				upgr.shot_speed_up = true
			9:
				upgr.ammo_up_three = true
			10:
				upgr.higher_damage = true
			11:
				upgr.piercing_once = true
		upgrades.append(upgr)
		upgr.player = self
		upgr.pickup()

func _ready():
	#generate_upgrades()
	set_animation("idle_or_walking", 0)
	set_animation("direction", 1)


func _physics_process(_delta):
	if !in_menu:
		if currently_reloading:
			if(reload_time > reload_timer):
				currently_reloading = false
				reload_time = 0
				ammo = ammo_max
			reload_time += 1
		else:
			walking_direction = Vector2.ZERO
			walking_direction.x = Input.get_axis("left", "right")
			walking_direction.y = Input.get_axis("up", "down")
			walking_direction = walking_direction.normalized()
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
			
			
			if Input.is_action_just_pressed("shoot") && ammo > 0 && shot_time >= shot_timer:
				shoot()
				shot_time = 0
				ammo -= 1
			
			if Input.is_action_just_pressed("reload") && ammo != ammo_max:
				currently_reloading = true
			
			shot_time += 1

func set_animation(animation_name, value):
	if animation_name == "direction":
		get_node("AnimationTree").set("parameters/direction_walking/current", value)
		get_node("AnimationTree").set("parameters/direction_idle/current", value)
	else:
		get_node("AnimationTree").set("parameters/" + animation_name + "/current", value)
func shoot():
	# make a new shot
	var ray = shot.instantiate()
	var raycast: RayCast2D = ray.get_node("RayCast2d")
	game.add_child(ray)
	# set position to player
	ray.get_node("RayCast2d").global_position = global_position
	# set target to mouse

	raycast.target_position = get_local_mouse_position().normalized() * 100000
	raycast.enabled = true
	raycast.force_raycast_update()
	ray.get_node("Line2d").add_point(raycast.global_position)
	ray.get_node("Line2d").add_point(raycast.get_collision_point())
	$FX/ShootFX.play()
	
	var hitNode = raycast.get_collider()
	if hitNode is Enemy:
		hitNode.takeDamage(25)
	
	for u in upgrades:
		if u.explosive_shot:
			var expl = load("res://Scenes/Explosion.tscn").instantiate()
			expl.global_position = ray.get_node("RayCast2d").get_collision_point()
			game.add_child(expl)
	
func upgrade():
	in_menu = true
	var upgrade_menu = load("res://Scenes/UpgradeScreen.tscn").instantiate()
	add_child(upgrade_menu)

func exit_menu():
	in_menu = false
	shot_time = 0

func takeDamage(damage_amount : int):
	if vulnerable == false:
		return
	
	health -= damage_amount
	print("Player health: ", health)
	if health <= 0:
		health = 0
		$AnimationPlayer.play("died")
		return
	
	vulnerable = false
	$AnimationPlayer.play("hurt")
	await $AnimationPlayer.animation_finished
	vulnerable = true

func _on_hurtbox_body_entered(body):
	if body is Enemy == false:
		return
	
	$FX/HurtFX.play()
