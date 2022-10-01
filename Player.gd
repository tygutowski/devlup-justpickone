extends CharacterBody2D


const SPEED = 100.0
var shot = preload("res://Shot.tscn")

@onready var game = get_tree().get_nodes_in_group("game")[0]

func _physics_process(delta):
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("left", "right")
	direction.y = Input.get_axis("up", "down")
	direction = direction.normalized()
	velocity = direction * SPEED
	move_and_slide()
	
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
	print("Player GP: " + str(global_position))
	ray.get_node("Line2d").add_point(ray.get_node("RayCast2d").global_position)
	ray.get_node("Line2d").add_point(ray.get_node("RayCast2d").get_collision_point())
	print("Hitscan: " + str(ray.get_node("RayCast2d").get_collision_point()))

func upgrade():
	pass
