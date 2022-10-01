extends CharacterBody2D

@onready var projectile = preload("res://Scenes/Projectile.tscn")

func _physics_process(_delta: float) -> void:
	shoot()

func shoot() -> void:
	if Input.is_action_just_pressed("shoot"):
		#print("shooting projectile")
		var inst: Projectile = projectile.instantiate()
		owner.add_child(inst)
		inst.transform = self.transform
		var look = get_viewport().get_mouse_position()
		inst.look_at(look)
		#create an offset so that it doesn't fire at the player's position
		inst.position += (look - self.position).normalized()*20
