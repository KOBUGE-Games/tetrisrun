extends Node2D

const TetrisBlock = preload("res://tetris_block/tetris_block.gd")
const TetrisBlockScene = preload("res://tetris_block/tetris_block.tscn")
export(NodePath) var runner_path = "../runner"
export(NodePath) var tilemap_path = "../tile_map"

onready var runner = get_node(runner_path)
onready var tilemap = get_node(tilemap_path)
var last_position = 0.0 # px
var same_position_time = 0.0 # s
var active_tetris_block = null

func _ready():
	randomize()
	pass

func _physics_process(delta):
	position.x = runner.position.x - 150
	
	if abs(last_position - runner.position.x) < global.runner_speed * delta / 2:
		same_position_time += delta
		if same_position_time > global.max_standing_time:
			runner.set_dead()
	else:
		same_position_time = 0.0
	
	last_position = runner.position.x
	
	if active_tetris_block == null:
		for shape_name in TetrisBlock.TetrisShapes:
			if Input.is_action_just_pressed("spawn_tetris_%s" % shape_name.to_lower()):
				spawn_tetris_block(TetrisBlock.TetrisShapes[shape_name])
				break

func spawn_tetris_block(shape):
	active_tetris_block = TetrisBlockScene.instance()
	get_parent().add_child(active_tetris_block)
	active_tetris_block.rotate_tetris(0)
	active_tetris_block.set_shape(shape)
	active_tetris_block.global_position = tilemap.map_to_world(tilemap.world_to_map($tile_spawn_pos.global_position)) + Vector2(16, 16)
	
	yield(active_tetris_block, "tree_exited")
	active_tetris_block = null

