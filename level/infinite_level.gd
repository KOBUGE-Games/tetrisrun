extends Node2D

const TILEMAP_SIZE = 32 # at least screen width + 4
const TILEMAP_HEIGHT = 18

var generator = preload("generator.gd").new()
onready var current_tilemap = $tile_map_a
onready var next_tilemap = $tile_map_b
onready var moving_frame = $moving_frame

onready var active_tilemap = next_tilemap # tetris blocks will be added to this

func _ready():
	fill_next_tilemap()

func _physics_process(delta):
	if moving_frame.position.x >= next_tilemap.position.x:
		swap_tilemaps()

func swap_tilemaps():
	active_tilemap = current_tilemap
	current_tilemap = next_tilemap
	next_tilemap = active_tilemap
	
	next_tilemap.position.x = current_tilemap.position.x + TILEMAP_SIZE * global.tile_size
	fill_next_tilemap()

func fill_next_tilemap():
	next_tilemap.clear()
	for i in range(TILEMAP_SIZE):
		var height = generator.generate_height()
		next_tilemap.set_cell(i, TILEMAP_HEIGHT - height, 0)
