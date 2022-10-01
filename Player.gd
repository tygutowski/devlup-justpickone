extends CharacterBody2D


const SPEED = 100.0
var shot = preload("res://Shot.tscn")
var walking_direction = Vector2.ZERO
var facing_direction = Vector2.ZERO

@onready var game = get_tree().get_nodes_in_group("game")[0]

func _physics_process(_delta):
	walking_direction = Vector2.ZERO
	walking_direction.x = Input.get_axis("left", "right")
	walking_direction.y = Input.get_axis("up", "down")
	walking_direction = walking_direction.normalized()
	velocity = walking_direction * SPEED
	move_and_slide()
	facing_direction = walking_direction
	if facing_direction == Vector2.ZERO:
		get_node("AnimationTree").set("params/idle_or_walking", 0) # Idle
	else:
		get_node("AnimationTree").set("params/idle_or_walking", 1) # Walking
		if facing_direction.x > 0: # Right
			get_node("AnimationTree").set("params/direction_walking", 2)
			get_node("AnimationTree").set("params/direction_idle", 2)
		elif facing_direction.x < 0: # Left
			get_node("AnimationTree").set("params/direction_walking", 3)
			get_node("AnimationTree").set("params/direction_idle", 3)
		elif facing_direction.y > 0: # Down
			get_node("AnimationTree").set("params/direction_walking", 1)
			get_node("AnimationTree").set("params/direction_idle", 1)
		elif facing_direction.y < 0: # Up
			get_node("AnimationTree").set("params/direction_walking", 0)
			get_node("AnimationTree").set("params/direction_idle", 0)
		
	if Input.is_action_just_pressed("shoot"):
		shoot()

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
