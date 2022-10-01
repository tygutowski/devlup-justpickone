extends CharacterBody2D


const SPEED = 100.0
var shot = preload("res://Scenes/Shot.tscn")
var walking_direction = Vector2.ZERO
var facing_direction = Vector2.ZERO

@onready var game = get_tree().get_first_node_in_group("game")

func _ready() -> void:
	set_animation("idle_or_walking", 0)
	set_animation("direction", 1)

func _physics_process(_delta: float) -> void:
	walking_direction = Vector2.ZERO
	walking_direction.x = Input.get_axis("left", "right")
	walking_direction.y = Input.get_axis("up", "down")
	walking_direction = walking_direction.normalized()
	velocity = walking_direction * SPEED
	move_and_slide()
	if walking_direction != Vector2.ZERO:
		facing_direction = walking_direction
		
	#print(walking_direction)
	### SCUFFED
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
		
	if Input.is_action_just_pressed("shoot"):
		shoot()

func set_animation(animation_name, value) -> void:
	if animation_name == "direction":
		get_node("AnimationTree").set("parameters/direction_walking/current", value)
		get_node("AnimationTree").set("parameters/direction_idle/current", value)
	else:
		get_node("AnimationTree").set("parameters/" + animation_name + "/current", value)

func shoot() -> void:
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
	
	$FX/ShootFX.play()

func upgrade():
	pass
 


func _on_hurtbox_body_entered(body):
	$FX/HurtFX.play()
