extends CharacterBody2D


var speed = 100.0
var shot = preload("res://Scenes/Shot.tscn")
var walking_direction = Vector2.ZERO
var facing_direction = Vector2.ZERO

var reload_timer = 60
var reload_time = 0

var ammo_max = 6
var ammo = ammo_max

var currently_reloading = false

var shot_timer = 10
var shot_time = shot_timer

@onready var game = get_tree().get_nodes_in_group("game")[0]

func _ready():
	set_animation("idle_or_walking", 0)
	set_animation("direction", 1)

func _physics_process(_delta):
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
	game.add_child(ray)
	# set position to player
	ray.get_node("RayCast2d").global_position = global_position
	# set target to mouse
	ray.get_node("RayCast2d").target_position = get_local_mouse_position().normalized() * 100000
	ray.get_node("RayCast2d").enabled = true
	ray.get_node("RayCast2d").force_raycast_update()
	ray.get_node("Line2d").add_point(ray.get_node("RayCast2d").global_position)
	ray.get_node("Line2d").add_point(ray.get_node("RayCast2d").get_collision_point())

func upgrade():
	pass
