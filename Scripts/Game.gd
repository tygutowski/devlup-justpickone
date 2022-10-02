extends Node2D

@export var pattern1: TileMapPattern
@onready var tilemap = get_tree().get_first_node_in_group("tilemap")

func _ready():
	
	for x in range(1,46):
		for y in range(1,46):
			var randomizer = randi_range(1, 50)
			if randomizer == 1:
				generate_square(x, y)
			elif randomizer == 2:
				generate_spawner(x, y)
func generate_square(start_x, start_y):
	tilemap.set_cell(0, Vector2(start_x + 0, start_y + 0), 0, Vector2(4, 0))
	tilemap.set_cell(0, Vector2(start_x + 1, start_y + 0), 0, Vector2(1, 3))
	tilemap.set_cell(0, Vector2(start_x + 2, start_y + 0), 0, Vector2(5, 0))
	
	tilemap.set_cell(0, Vector2(start_x + 0, start_y + 1), 0, Vector2(3, 2))
	tilemap.set_cell(0, Vector2(start_x + 1, start_y + 1), 0, Vector2(6, 0))
	tilemap.set_cell(0, Vector2(start_x + 2, start_y + 1), 0, Vector2(0, 2))
	
	tilemap.set_cell(0, Vector2(start_x + 0, start_y + 2), 0, Vector2(4, 1))
	tilemap.set_cell(0, Vector2(start_x + 1, start_y + 2), 0, Vector2(2, 0))
	tilemap.set_cell(0, Vector2(start_x + 2, start_y + 2), 0, Vector2(5, 1))

func generate_spawner(x, y):
	var spawner = load("res://Scenes/Spawner.tscn").instantiate()
	add_child(spawner)
	spawner.global_position = Vector2(x * 16, y * 16) # i forgot cell to vector function
