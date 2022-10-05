extends Enemy

@onready var projectile := preload("res://Scenes/Projectile.tscn")
@onready var chaserenemy := preload("res://Scenes/ChaserEnemy.tscn")
@onready var kamikazeenemy := preload("res://Scenes/KamikazeEnemy.tscn")

var spawn_count := 5
var timer_between_spawn := randi_range(0, 600)
var time_between_spawn := 0

func _ready():
	super._ready()
	health = 20

func _physics_process(_delta: float) -> void:
	time_between_spawn += 1
	if time_between_spawn >= timer_between_spawn:
		$FX/SpawningFX.play()
		($SpawningParticles as GPUParticles2D).emitting = true
		spawn(randi_range(1,2))
		#print("spawning")
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
		get_tree().get_first_node_in_group("game").add_child(inst)
