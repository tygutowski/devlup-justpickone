extends CharacterBody2D

@onready var projectile = preload("res://Scenes/Projectile.tscn")
@onready var chaserenemy = preload("res://Scenes/ChaserEnemy.tscn")

var spawn_count: int = 5

func _physics_process(_delta: float) -> void:
#	shoot()
	spawn()

func spawn() -> void:
	if Input.is_action_just_pressed("shoot") and spawn_count > 0:
		spawn_count -= 1
		#print("shooting projectile")
		var inst: Enemy = chaserenemy.instantiate()
		owner.add_child(inst)
		
		#set to spawner location
		inst.position = self.position

func shoot() -> void:
	if Input.is_action_just_pressed("shoot"):
		#print("shooting projectile")
		var inst: Projectile = projectile.instantiate()
		owner.add_child(inst)
		
		#set to spawner location
		inst.position = self.position

		#look_at direction
		var look = get_viewport().get_mouse_position()
		inst.look_at(look)
		var angle = inst.transform.get_rotation()
		inst.direction = Vector2(cos(angle), sin(angle))

		#create an offset so that it doesn't fire at the player's position
		inst.position += (look - self.position).normalized()*20
