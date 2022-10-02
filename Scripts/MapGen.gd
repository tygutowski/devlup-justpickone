extends Node2D

var pos = Vector2(3,3)
var off = Vector2(3,3)
var size = 25

# Called when the node enters the scene tree for the first time.
func _ready():
	do_noise(size)
	stretch()
	auto_tile()

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

func stretch_rows(off):
	var r = $TileMap.get_used_rect( )
	var right = r.position.x + r.size.x
	var bottom = r.position.y + r.size.y
	for j in range(r.size.y):
		var arr = []
		for i in range(r.position.x , right):
			arr += [ $TileMap.get_cell_atlas_coords(0, Vector2(i,j+r.position.y)) ]

		for i in len(arr):
			var t = arr[i]
			set_cell(2*i  , j, off, t)
			set_cell(2*i+1, j, off, t)

func stretch_cols(off):
	var r = $TileMap.get_used_rect( )
	var right = r.position.x + r.size.x
	var bottom = r.position.y + r.size.y
	for i in range(r.size.x):
		var arr = []
		for j in range(r.position.y , bottom):
			arr += [ $TileMap.get_cell_atlas_coords(0, Vector2(i+r.position.x,j)) ]

		for j in len(arr):
			var t = arr[j]
			set_cell(i,   2*j, off, t)
			set_cell(i, 2*j+1, off, t)

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

func setpit(i,j):
	var locs = $TileMap.get_surrounding_tiles ( Vector2(3,3) )
	var a = $TileMap.get_cell_atlas_coords(0,locs[0])
	var b = $TileMap.get_cell_atlas_coords(0,locs[1])
	var c = $TileMap.get_cell_atlas_coords(0,locs[2])
	var d = $TileMap.get_cell_atlas_coords(0,locs[3])
#	surr = $TileMap.get_surrounding_tiles ( Vector2(i+1,j+1) )
	print(a,b,c,d)

func generate_base(s, o):
	for i in s.x:
		for j in s.y:
			set_cell(i, j, o)

func set_cell(i, j, off, tile=Vector2(i,j) ):
	$TileMap.set_cell(0, Vector2(i+off.x,j+off.y), 0, tile )
