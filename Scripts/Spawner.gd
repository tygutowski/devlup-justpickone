extends CharacterBody2D

@onready var projectile = preload("res://Scenes/Projectile.tscn")
@onready var chaserenemy = preload("res://Scenes/ChaserEnemy.tscn")
@onready var kamikazeenemy = preload("res://Scenes/KamikazeEnemy.tscn")

var spawn_count: int = 5
var timer_between_spawn
var time_between_spawn = 0

func _ready():
	timer_between_spawn = randi_range(0, 600)

func _physics_process(_delta: float) -> void:
	time_between_spawn += 1
	if time_between_spawn >= timer_between_spawn:
		spawn(randi_range(1,2))
		timer_between_spawn = randi_range(0, 600)
		time_between_spawn = 0

func spawn(selector: int) -> void:
	match selector:
		#0: shoot(projectile, 50, 500)
		1: create_enemy(chaserenemy)
		2: create_enemy(kamikazeenemy)

func create_enemy(enemy):
	if spawn_count > 0:
		spawn_count -= 1
		var inst: Enemy = enemy.instantiate()
		inst.global_position = global_position
		add_child(inst)
		
		#set to spawner location
		inst.position = self.position

func shoot(projectilenode, bounces, speed) -> void:
		#print("shooting projectile")
		var inst: Projectile = projectilenode.instantiate()
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
		inst.bounces = bounces
		inst.speed = speed
