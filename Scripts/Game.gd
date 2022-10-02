extends Node2D

@export var pattern1: TileMapPattern
@onready var tilemap = get_tree().get_first_node_in_group("tilemap")

@onready var boss_scene = load("res://Scenes/Boss.tscn")
@onready var player_scene = load("res://Scenes/Player.tscn")
@onready var chaser_scene = load("res://Scenes/ChaserEnemy.tscn")
@onready var boomer_scene = load("res://Scenes/KamikazeEnemy.tscn")
@onready var spawner_scene = load("res://Scenes/Spawner.tscn")
@onready var upgrade_scene = load("res://Scenes/Pickup.tscn")
var pos = Vector2(3,3)
var off = Vector2(3,3)
var size = 25
var game_started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	do_noise(size)
	stretch()
	auto_tile()
	spawn_enemies(0)
	spawn_upgrade()
	spawn_player()

func spawn_boss():
	var rand_x = randi_range(25, 850)
	var rand_y = randi_range(25, 850)
	var boss_instance = boss_scene.instantiate()
	boss_instance.global_position = Vector2(rand_x, rand_y)
	add_child(boss_instance)

func move_player():
	var rand_x = randi_range(25, 850)
	var rand_y = randi_range(25, 850)
	get_node("Player").global_position = Vector2(rand_x, rand_y)

func spawn_upgrade():
	for i in range(1):
		var rand_x = randi_range(25, 850)
		var rand_y = randi_range(25, 850)
		var upgrade_instance = upgrade_scene.instantiate()
		upgrade_instance.global_position = Vector2(rand_x, rand_y)
		add_child(upgrade_instance)
func spawn_enemies(num):
	if num == 0:
		num = 3 * randi_range(1, 2 * LevelGenerator.level)
	for i in range(num):
		var enemy_spawn = randi_range(0,2)
		var rand_x = randi_range(25, 850)
		var rand_y = randi_range(25, 850)
		if enemy_spawn == 0:
			var chaser_instance = chaser_scene.instantiate()
			chaser_instance.global_position = Vector2(rand_x, rand_y)
			add_child(chaser_instance)
		if enemy_spawn == 1:
			var boomer_instance = boomer_scene.instantiate()
			boomer_instance.global_position = Vector2(rand_x, rand_y)
			add_child(boomer_instance)
		if enemy_spawn == 2:
			var spawner_instance = spawner_scene.instantiate()
			spawner_instance.global_position = Vector2(rand_x, rand_y)
			add_child(spawner_instance)

func spawn_player():
	var rand_x = randi_range(25, 850)
	var rand_y = randi_range(25, 850)
	var player_instance = player_scene.instantiate()
	player_instance.global_position = Vector2(rand_x, rand_y)
	add_child(player_instance)

func check_any_enemies(): # ignored last enemy that hasnt freed yet
	print("Checking if there's any enemies left!")
	var enemies_left = 1
	for node in get_children():
		if node.is_in_group("enemy"):
			enemies_left += 1
	if enemies_left >=1:
		spawn_boss()

func do_noise(s):
	$TileMap.clear()
	randomize()
	var noise = FastNoiseLite.new()
	noise.noise_type = 0 # perlin
	noise.seed = randi()
	noise.frequency = 0.4
	for i in s:
		for j in s:
			if noise.get_noise_2d(i,j) < 0.2:
				set_cell(i,j,off,Vector2(2,2))

func auto_tile():
	var r = $TileMap.get_used_rect( )
	var right  = r.position.x + r.size.x
	var bottom = r.position.y + r.size.y
	var changes = []
	for i in range(r.position.x - 1, right+1):
		for j in range(r.position.y - 1, bottom+1):
			changes += selector(i, j, get_3x3(i,j))
	for c in changes:
		set_cell(c[0], c[1], Vector2(0,0), c[2])

func get_3x3(x,y):
	var tiles = []
	for i in range(x-1,x+2):
		for j in range(y-1,y+2):
			tiles += [ $TileMap.get_cell_atlas_coords(0, Vector2(i,j) ) ]
	return tiles

func selector(i, j, t):
	var changes = []
	var e = Vector2i(-1,-1)
	# lt, lm, lb, mt, mm, mb, rt, rm, rb
	# corners
	if t[0]==e and t[1]==e and t[2]==e and t[3]==e and t[4]==e and t[5]==e and t[6]==e and t[7]==e and t[8]!=e:
		changes += [[i, j, Vector2(0,0)]]
	if t[0]!=e and t[1]==e and t[2]==e and t[3]==e and t[4]==e and t[5]==e and t[6]==e and t[7]==e and t[8]==e:
		changes += [[i, j, Vector2(3,3)]]
	if t[0]==e and t[1]==e and t[2]!=e and t[3]==e and t[4]==e and t[5]==e and t[6]==e and t[7]==e and t[8]==e:
		changes += [[i, j, Vector2(3,0)]]
	if t[0]==e and t[1]==e and t[2]==e and t[3]==e and t[4]==e and t[5]==e and t[6]!=e and t[7]==e and t[8]==e:
		changes += [[i, j, Vector2(0,3)]]
#		set_cell(i, j, Vector2(0,0), Vector2(0,3) )

	# lt0, lm, lb2, mt, mm4, mb, rt6, rm, rb8
	# flat wall
	var a = (t[0]!=e and t[1]!=e and t[2]!=e and t[3]==e and t[4]==e and t[5]==e and t[6]==e and t[7]==e and t[8]==e)
	var b = (t[0]==e and t[1]!=e and t[2]!=e and t[3]==e and t[4]==e and t[5]==e and t[6]==e and t[7]==e and t[8]==e)
	var c = (t[0]!=e and t[1]!=e and t[2]==e and t[3]==e and t[4]==e and t[5]==e and t[6]==e and t[7]==e and t[8]==e)
	if a or b or c:
		changes += [[i, j, Vector2(3,1)]]
	a = (t[0]!=e and t[1]==e and t[2]==e and t[3]!=e and t[4]==e and t[5]==e and t[6]!=e and t[7]==e and t[8]==e)
	b = (t[0]==e and t[1]==e and t[2]==e and t[3]!=e and t[4]==e and t[5]==e and t[6]!=e and t[7]==e and t[8]==e)
	c = (t[0]!=e and t[1]==e and t[2]==e and t[3]!=e and t[4]==e and t[5]==e and t[6]==e and t[7]==e and t[8]==e)
	if a or b or c:
		changes += [[i, j, Vector2(1,3)]]
	a = t[0]==e and t[1]==e and t[2]!=e and t[3]==e and t[4]==e and t[5]!=e and t[6]==e and t[7]==e and t[8]!=e
	b = t[0]==e and t[1]==e and t[2]==e and t[3]==e and t[4]==e and t[5]!=e and t[6]==e and t[7]==e and t[8]!=e
	c = t[0]==e and t[1]==e and t[2]!=e and t[3]==e and t[4]==e and t[5]!=e and t[6]==e and t[7]==e and t[8]==e
	if a or b or c:
		changes += [[i, j, Vector2(1,0)]]
	a = t[0]==e and t[1]==e and t[2]==e and t[3]==e and t[4]==e and t[5]==e and t[6]!=e and t[7]!=e and t[8]!=e
	b = t[0]==e and t[1]==e and t[2]==e and t[3]==e and t[4]==e and t[5]==e and t[6]==e and t[7]!=e and t[8]!=e
	c = t[0]==e and t[1]==e and t[2]==e and t[3]==e and t[4]==e and t[5]==e and t[6]!=e and t[7]!=e and t[8]==e
	if a or b or c:
		changes += [[i, j, Vector2(0,1)]]

	# lt0, lm, lb2, mt, mm4, mb, rt6, rm, rb8
	# inside corners
	a = t[1]!=e and t[3]!=e and t[4]==e
	if a: #top left
		changes += [[i, j, Vector2(4,0)]]
	a = t[3]!=e and t[4]==e and t[7]!=e
	if a: #top right
		changes += [[i, j, Vector2(5,0)]]
	a = t[5]!=e and t[4]==e and t[7]!=e
	if a: #bottom right
		changes += [[i, j, Vector2(5,1)]]
	a = t[1]!=e and t[5]!=e and t[4]==e
	if a: #bottom left
		changes += [[i, j, Vector2(4,1)]]

	# lt0, lm, lb2, mt, mm4, mb, rt6, rm, rb8
	# shadowed walls
	a = t[1]==e and t[3]!=e and t[4]!=e
	if a: #left shadow
		changes += [[i, j, Vector2(1,2)]]
	a = t[1]==e and t[3]==e and t[4]!=e
	if a: #corner shadow
		changes += [[i, j, Vector2(1,1)]]
	a = t[1]!=e and t[3]==e and t[4]!=e
	if a: #top shadow
		changes += [[i, j, Vector2(2,1)]]

	return changes

func stretch():
	stretch_rows(off)
	stretch_cols(off)

func stretch_rows(p_off):
	var r = $TileMap.get_used_rect( )
	var right = r.position.x + r.size.x
	for j in range(r.size.y):
		var arr = []
		for i in range(r.position.x , right):
			arr += [ $TileMap.get_cell_atlas_coords(0, Vector2(i,j+r.position.y)) ]

		for i in len(arr):
			var t = arr[i]
			set_cell(2*i  , j, p_off, t)
			set_cell(2*i+1, j, p_off, t)

func stretch_cols(p_off):
	var r = $TileMap.get_used_rect( )
	var bottom = r.position.y + r.size.y
	for i in range(r.size.x):
		var arr = []
		for j in range(r.position.y , bottom):
			arr += [ $TileMap.get_cell_atlas_coords(0, Vector2(i+r.position.x,j)) ]

		for j in len(arr):
			var t = arr[j]
			set_cell(i,   2*j, p_off, t)
			set_cell(i, 2*j+1, p_off, t)

func extend_base_x():
	var r = $TileMap.get_used_rect ( )
	var right = r.position.x + r.size.x
	var bottom = r.position.y + r.size.y
	for i in range(right-1, right-3, -1):
		for j in range(r.position.y, bottom):
			var tile = $TileMap.get_cell_atlas_coords(0, Vector2(i,j))
			set_cell(i+1, j, Vector2(0,0), tile)

func extend_base_y():
	var r = $TileMap.get_used_rect ( )
	var right = r.position.x + r.size.x
	var bottom = r.position.y + r.size.y
	for j in range(bottom, bottom-3, -1):
		for i in range(r.position.x, right):
			var tile = $TileMap.get_cell_atlas_coords(0, Vector2(i,j))
			set_cell(i, j+1, Vector2(0,0), tile)

func setpit(_i,_j):
	var locs = $TileMap.get_surrounding_tiles ( Vector2(3,3) )
	var a = $TileMap.get_cell_atlas_coords(0,locs[0])
	var b = $TileMap.get_cell_atlas_coords(0,locs[1])
	var c = $TileMap.get_cell_atlas_coords(0,locs[2])
	var d = $TileMap.get_cell_atlas_coords(0,locs[3])
#	surr = $TileMap.get_surrounding_tiles ( Vector2(i+1,j+1) )

func generate_base(s, o):
	for i in s.x:
		for j in s.y:
			set_cell(i, j, o)

func set_cell(p_i, p_j, p_off, tile=Vector2(p_i,p_j)):
	$TileMap.set_cell(0, Vector2(p_i+p_off.x,p_j+p_off.y), 0, tile )
