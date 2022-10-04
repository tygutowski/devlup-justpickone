class_name Game
extends Node2D

@export var pattern1: TileMapPattern
@onready var tilemap : TileMap = get_tree().get_first_node_in_group("tilemap")

var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var pos := Vector2(3,3)
var off := Vector2(0,0)
var size := 30
var M := []

@onready var boss_scene := preload("res://Scenes/Boss.tscn")
@onready var player_scene := preload("res://Scenes/Player.tscn")
@onready var chaser_scene := preload("res://Scenes/ChaserEnemy.tscn")
@onready var boomer_scene := preload("res://Scenes/KamikazeEnemy.tscn")
@onready var spawner_scene := preload("res://Scenes/Spawner.tscn")
@onready var upgrade_scene := preload("res://Scenes/Pickup.tscn")

var game_started := false

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	do_noise(size)
	fix_holes()
	stretch()
	auto_tile()
#	#print(sum(M))
	spawn_player()
	spawn_enemies(1 + 2 * LevelGenerator.level)
	spawn_upgrade(2 * LevelGenerator.level)
	spawn_boss()
	spawn_stairs()
	
func get_open_map_point() -> Vector2i:
	var s := find_random_n(M, 2)
	var x : int = s[1]*2 + off.y
	var y : int = s[0]*2 + off.x
	return Vector2i(x, y) #row and column switching from (x,y)

func fix_holes():
	M = construct_matrix()
	var s := sum(M)
#	#print_M(M)
#	#print(s)
#	#print_M(copy_M(M))
#	#print(find_random_n(M, 1))
	var A := traverse(M)
	var holes := find_n(A, 1)
	for hole in holes:
		fix_hole(A, hole)
#	#print_M(A)
	patch(A)
	M = copy_M(A)
#	#print(sum(A)/2)

func patch(A):
	$TileMap.clear()
	for i in range(len(A)):
		for j in range(len(A[0])):
			if A[i][j] == 2:
				set_cell(j,i,off,Vector2i(2,2))
			if A[i][j] == 0:
				set_cell(j,i,off,Vector2i(6,0))

func fix_hole(A, h):
	if A[h[0]][h[1]] != 2:
		var data := find_nearest_n_from(A, h[0], h[1], 2)
		A[h[0]][h[1]] = 2
		var mx = min(data[0][0], h[0])
		var Mx = max(data[0][0], h[0])
		var my = min(data[0][1], h[1])
		var My = max(data[0][1], h[1])
#		#print( mx, Mx, my, My)
#		#print(data, h)
		for i in range(mx, Mx):
			A[i][h[1]] = 2

		for j in range(my, My):
			A[h[0]][j] = 2
		
#		var neighs = get_valid_orthogonal_neighbors_n(A, h[0], h[1], 0)
#		if 0 < len(neighs):
#			var continue_recurse = true
#			for n in neighs:
#				if A[n[0]][n[1]] >= 2:
#					continue_recurse = false
#			if continue_recurse:
#				fix_hole(A, neighs[0])
	
func find_nearest_n_from(A, x, y, n) -> Array:
	var d := len(A) + len(A[0])
	var closest := [-1,-1]
	for i in range(len(A)):
		for j in range(len(A[0])):
			if A[i][j] == n:
				var dp = abs(x-i) + abs(y-j)
				if dp < d:
					d = dp
					closest = [i,j]
	return [closest, d]

func traverse(M) -> Array:
	var A := copy_M(M)
	var v := find_random_n(A, 1)
	traverse_from(A, v[0], v[1])
#	#print_M(A)
	return A

func find_n(A, n) -> Array:
	var arr := []
	for i in range(len(A)):
		for j in range(len(A[0])):
			if A[i][j] == n:
				arr += [[i,j]]
	return arr

func get_valid_orthogonal_neighbors_n(A, i, j, n) -> Array:
	var neigh := []
	var a := add_neighbor(A, i+1, j, n, neigh)
	if 0 < len(a): neigh += a
	a = add_neighbor(A, i-1, j, n, neigh)
	if 0 < len(a): neigh += a
	a = add_neighbor(A, i, j+1, n, neigh)
	if 0 < len(a): neigh += a
	a = add_neighbor(A, i, j-1, n, neigh)
	if 0 < len(a): neigh += a
	return neigh

func add_neighbor(A, x, y, n, neigh) -> Array:
	if inbounds(A, x, y):
		if A[x][y] == n:
			return [[x,y]]
	return []

func traverse_from(A, i, j):
	if inbounds(A, i, j):
		if A[i][j] == 1:
			A[i][j] = 2
			traverse_from(A, i+1, j)
			traverse_from(A, i-1, j)
			traverse_from(A, i, j+1)
			traverse_from(A, i, j-1)

func inbounds(A, i, j) -> bool:
	return 0 <= i and i < len(A) and 0 <= j and j < len(A[0])

func find_random_n(A, n) -> Array:
	while true:
		# range is inclusive, the size isn't a valid index
		var i = rng.randi_range(0, len(A) - 1 )
		var j = rng.randi_range(0, len(A[0]) - 1)
		if A[i][j] == n:
			return [i,j]
	return []

func print_M(A):
	for i in len(A):
		print(A[i])

func sum(A) -> int:
	var s := 0
	for i in range(len(A)):
		for j in range(len(A[0])):
			s += A[i][j]
	return s

func copy_M(Z) -> Array:
	var A := []
	for i in range(len(Z)):
		var arr := []
		for j in range(len(Z[0])):
			arr += [Z[i][j]]
		A += [arr]
	return A

func construct_matrix() -> Array:
	var r := ($TileMap as TileMap).get_used_rect( )
	var M := []
	var e := Vector2i(6,0)
	#flipped i and j to align matrix with result, rows first
	for j in range( r.position.y, r.position.y + r.size.y ):
		var arr := []
		for i in range( r.position.x, r.position.x + r.size.x ):
			var cell := ($TileMap as TileMap).get_cell_atlas_coords( 0, Vector2i(i,j) )
			arr += [ 1 if cell != e else 0 ]
		M += [arr]
	return M

func spawn_boss():
	var rand_x := randi_range(25, 850)
	var rand_y := randi_range(25, 850)
	var boss_instance := boss_scene.instantiate()
	boss_instance.global_position = Vector2(rand_x, rand_y)
	add_child(boss_instance)

func spawn_stairs() -> void:
	var new_position := Vector2i(
		randi_range(25, 850),
		randi_range(25, 850)
	)
	var stair_instance : Node2D = load("res://Scenes/Stairs.tscn").instantiate()
	stair_instance.global_position = new_position
	add_child(stair_instance)

func move_player() -> void:
	var rand_x := randi_range(25, 850)
	var rand_y := randi_range(25, 850)
	get_node("Player").global_position = Vector2(rand_x, rand_y)

func spawn_upgrade(num) -> void:
	for i in range(num):
		var rand_x := randi_range(25, 850)
		var rand_y := randi_range(25, 850)
		var upgrade_instance := upgrade_scene.instantiate()
		upgrade_instance.global_position = Vector2(rand_x, rand_y)
		add_child(upgrade_instance)
	
func spawn_enemies(num):
	for i in range(num):
		var enemy_spawn := randi_range(0,2)
		var rand_x := randi_range(25, 850)
		var rand_y := randi_range(25, 850)
		if enemy_spawn == 0:
			var chaser_instance := chaser_scene.instantiate()
			chaser_instance.global_position = Vector2(rand_x, rand_y)
			add_child(chaser_instance)
		if enemy_spawn == 1:
			var boomer_instance := boomer_scene.instantiate()
			boomer_instance.global_position = Vector2(rand_x, rand_y)
			add_child(boomer_instance)
		if enemy_spawn == 2:
			var spawner_instance := spawner_scene.instantiate()
			spawner_instance.global_position = Vector2(rand_x, rand_y)
			add_child(spawner_instance)

func spawn_player() -> void:
	var player_instance := player_scene.instantiate()
	player_instance.global_position = Vector2(5, 5)
	add_child(player_instance)

func check_any_enemies(): # ignored last enemy that hasnt freed yet
	pass

func do_noise(s) -> void:
	$TileMap.clear()
	var noise := FastNoiseLite.new()
	noise.noise_type = 0 # perlin
	noise.seed = randi()
	noise.frequency = 0.1
	for i in s:
		for j in s:
			if noise.get_noise_2d(i,j) < 0.1:
				set_cell(i,j,off,Vector2i(2,2))
			else:
				set_cell(i,j,off,Vector2i(6,0))

func auto_tile():
	var r := ($TileMap as TileMap).get_used_rect( )
	var right  := r.position.x + r.size.x
	var bottom := r.position.y + r.size.y
	var changes := []
	for i in range(r.position.x - 1, right+1):
		for j in range(r.position.y - 1, bottom+1):
			changes += selector(i, j, get_3x3(i,j))
	for c in changes:
		set_cell(c[0], c[1], Vector2i(0,0), c[2])

func get_3x3(x,y) -> Array:
	var tiles := []
	for i in range(x-1,x+2):
		for j in range(y-1,y+2):
			tiles += [ $TileMap.get_cell_atlas_coords(0, Vector2i(i,j) ) ]
	return tiles

func selector(i, j, t) -> Array:
	var changes := []
	var e := Vector2i(6,0)
	# lt, lm, lb, mt, mm, mb, rt, rm, rb
	# corners
	if t[0]==e and t[1]==e and t[2]==e and t[3]==e and t[4]==e and t[5]==e and t[6]==e and t[7]==e and t[8]!=e:
		changes += [[i, j, Vector2i(0,0)]]
	if t[0]!=e and t[1]==e and t[2]==e and t[3]==e and t[4]==e and t[5]==e and t[6]==e and t[7]==e and t[8]==e:
		changes += [[i, j, Vector2i(3,3)]]
	if t[0]==e and t[1]==e and t[2]!=e and t[3]==e and t[4]==e and t[5]==e and t[6]==e and t[7]==e and t[8]==e:
		changes += [[i, j, Vector2i(3,0)]]
	if t[0]==e and t[1]==e and t[2]==e and t[3]==e and t[4]==e and t[5]==e and t[6]!=e and t[7]==e and t[8]==e:
		changes += [[i, j, Vector2i(0,3)]]
#		set_cell(i, j, Vector2(0,0), Vector2(0,3) )

	# lt0, lm, lb2, mt, mm4, mb, rt6, rm, rb8
	# flat wall
	var a : bool = (t[0]!=e and t[1]!=e and t[2]!=e and t[3]==e and t[4]==e and t[5]==e and t[6]==e and t[7]==e and t[8]==e)
	var b : bool = (t[0]==e and t[1]!=e and t[2]!=e and t[3]==e and t[4]==e and t[5]==e and t[6]==e and t[7]==e and t[8]==e)
	var c : bool = (t[0]!=e and t[1]!=e and t[2]==e and t[3]==e and t[4]==e and t[5]==e and t[6]==e and t[7]==e and t[8]==e)
	if a or b or c:
		changes += [[i, j, Vector2i(3,1)]]
	a = (t[0]!=e and t[1]==e and t[2]==e and t[3]!=e and t[4]==e and t[5]==e and t[6]!=e and t[7]==e and t[8]==e)
	b = (t[0]==e and t[1]==e and t[2]==e and t[3]!=e and t[4]==e and t[5]==e and t[6]!=e and t[7]==e and t[8]==e)
	c = (t[0]!=e and t[1]==e and t[2]==e and t[3]!=e and t[4]==e and t[5]==e and t[6]==e and t[7]==e and t[8]==e)
	if a or b or c:
		changes += [[i, j, Vector2i(1,3)]]
	a = t[0]==e and t[1]==e and t[2]!=e and t[3]==e and t[4]==e and t[5]!=e and t[6]==e and t[7]==e and t[8]!=e
	b = t[0]==e and t[1]==e and t[2]==e and t[3]==e and t[4]==e and t[5]!=e and t[6]==e and t[7]==e and t[8]!=e
	c = t[0]==e and t[1]==e and t[2]!=e and t[3]==e and t[4]==e and t[5]!=e and t[6]==e and t[7]==e and t[8]==e
	if a or b or c:
		changes += [[i, j, Vector2i(1,0)]]
	a = t[0]==e and t[1]==e and t[2]==e and t[3]==e and t[4]==e and t[5]==e and t[6]!=e and t[7]!=e and t[8]!=e
	b = t[0]==e and t[1]==e and t[2]==e and t[3]==e and t[4]==e and t[5]==e and t[6]==e and t[7]!=e and t[8]!=e
	c = t[0]==e and t[1]==e and t[2]==e and t[3]==e and t[4]==e and t[5]==e and t[6]!=e and t[7]!=e and t[8]==e
	if a or b or c:
		changes += [[i, j, Vector2i(0,1)]]

	# lt0, lm, lb2, mt, mm4, mb, rt6, rm, rb8
	# inside corners
	a = t[1]!=e and t[3]!=e and t[4]==e
	if a: #top left
		changes += [[i, j, Vector2i(4,0)]]
	a = t[3]!=e and t[4]==e and t[7]!=e
	if a: #top right
		changes += [[i, j, Vector2i(5,0)]]
	a = t[5]!=e and t[4]==e and t[7]!=e
	if a: #bottom right
		changes += [[i, j, Vector2i(5,1)]]
	a = t[1]!=e and t[5]!=e and t[4]==e
	if a: #bottom left
		changes += [[i, j, Vector2i(4,1)]]

	# lt0, lm, lb2, mt, mm4, mb, rt6, rm, rb8
	# shadowed walls
	a = t[1]==e and t[3]!=e and t[4]!=e
	if a: #left shadow
		changes += [[i, j, Vector2i(1,2)]]
	a = t[1]==e and t[3]==e and t[4]!=e
	if a: #corner shadow
		changes += [[i, j, Vector2i(1,1)]]
	a = t[1]!=e and t[3]==e and t[4]!=e
	if a: #top shadow
		changes += [[i, j, Vector2i(2,1)]]

	return changes

func stretch():
	stretch_rows(off)
	stretch_cols(off)

func stretch_rows(p_off):
	var r := ($TileMap as TileMap).get_used_rect( )
	var right := r.position.x + r.size.x
	for j in range(r.size.y):
		var arr := []
		for i in range(r.position.x , right):
			arr += [ ($TileMap as TileMap).get_cell_atlas_coords(0, Vector2i(i,j+r.position.y)) ]

		for i in len(arr):
			var t = arr[i]
			set_cell(2*i  , j, p_off, t)
			set_cell(2*i+1, j, p_off, t)

func stretch_cols(p_off):
	var r := ($TileMap as TileMap).get_used_rect( )
	var bottom := r.position.y + r.size.y
	for i in range(r.size.x):
		var arr := []
		for j in range(r.position.y , bottom):
			arr += [ $TileMap.get_cell_atlas_coords(0, Vector2i(i+r.position.x,j)) ]

		for j in len(arr):
			var t = arr[j]
			set_cell(i,   2*j, p_off, t)
			set_cell(i, 2*j+1, p_off, t)

func extend_base_x() -> void:
	var r := ($TileMap as TileMap).get_used_rect ( )
	var right := r.position.x + r.size.x
	var bottom := r.position.y + r.size.y
	for i in range(right-1, right-3, -1):
		for j in range(r.position.y, bottom):
			var tile := ($TileMap as TileMap).get_cell_atlas_coords(0, Vector2i(i,j))
			set_cell(i+1, j, Vector2i(0,0), tile)

func extend_base_y() -> void:
	var r := ($TileMap as TileMap).get_used_rect ( )
	var right := r.position.x + r.size.x
	var bottom := r.position.y + r.size.y
	for j in range(bottom, bottom-3, -1):
		for i in range(r.position.x, right):
			var tile := ($TileMap as TileMap).get_cell_atlas_coords(0, Vector2i(i,j))
			set_cell(i, j+1, Vector2i(0,0), tile)

#func setpit(_i,_j):
#	var locs = $TileMap.get_surrounding_tiles ( Vector2(3,3) )
#	var a = $TileMap.get_cell_atlas_coords(0,locs[0])
#	var b = $TileMap.get_cell_atlas_coords(0,locs[1])
#	var c = $TileMap.get_cell_atlas_coords(0,locs[2])
#	var d = $TileMap.get_cell_atlas_coords(0,locs[3])
##	surr = $TileMap.get_surrounding_tiles ( Vector2(i+1,j+1) )

func generate_base(s, o) -> void:
	for i in s.x:
		for j in s.y:
			set_cell(i, j, o)

func set_cell(p_i, p_j, p_off, tile=Vector2i(p_i,p_j)) -> void:
	($TileMap as TileMap).set_cell(0, Vector2i(p_i+p_off.x,p_j+p_off.y), 0, tile )
