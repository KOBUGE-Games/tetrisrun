extends KinematicBody2D

const TetrisShapes = {
	ShapeA = [Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0), Vector2(0, 1)],
	ShapeS = [Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0), Vector2(2, 0)],
	ShapeD = [Vector2(0, 0), Vector2(1, 0), Vector2(0, 1), Vector2(1, 1)],
	ShapeC = [Vector2(-1, 1), Vector2(1, 0), Vector2(0, 1), Vector2(1, 1)],
	ShapeF = [Vector2(0, 0), Vector2(2, 1), Vector2(0, 1), Vector2(1, 1)],
	ShapeV = [Vector2(-1, 1), Vector2(0, 0), Vector2(1, 0), Vector2(0, 1)],
	ShapeG = [Vector2(-1, 0), Vector2(0, 1), Vector2(1, 1), Vector2(0, 0)],
}
onready var pieces = [$piece1, $piece2, $piece3, $piece4]
var tile_colors = range(2, 6)
var shape = []
var color = 0
var fall_time_left = 0
var move_time_left = 0
var movement = 0

func _ready():
	randomize()
	shape = TetrisShapes.values()[randi() % TetrisShapes.size()]
	rotate_tetris(randi() % 4)
	color = tile_colors[randi() % tile_colors.size()]
	update_shape()

func _physics_process(delta):
	fall_time_left -= delta
	move_time_left -= delta
	
	if Input.is_action_just_pressed("rotate_tetris_left"):
		rotate_tetris(-1)
	if Input.is_action_just_pressed("rotate_tetris_right"):
		rotate_tetris(1)
	
	if Input.is_action_just_pressed("move_tetris_left"):
		movement = -1
	elif Input.is_action_pressed("move_tetris_left"):
		if movement > 0: movement = 0
		movement -= 1 * delta
	if Input.is_action_just_pressed("move_tetris_right"):
		movement = 1
	elif Input.is_action_pressed("move_tetris_right"):
		if movement < 0: movement = 0
		movement += 1 * delta
	
	if move_time_left < 0:
		if abs(movement) > 0.2:
			move_and_collide(Vector2(sign(movement), 0) * global.tile_size)
			movement = 0
		move_time_left = global.tile_size / global.tile_movement_speed
	
	if fall_time_left < 0:
		var collision = move_and_collide(Vector2(0, 1) * global.tile_size)
		
		if Input.is_action_pressed("move_tetris_down"):
			fall_time_left += global.tile_size / global.tile_fast_falling_speed
		else:
			fall_time_left += global.tile_size / global.tile_falling_speed
			
		if collision != null and collision.collider is TileMap:
			solidify(collision.collider)

func rotate_tetris(quaterturns):
	rotate(quaterturns * PI / 2)
	for piece in pieces:
		piece.rotate(- quaterturns * PI / 2)

func update_shape():
	for i in pieces.size():
		pieces[i].position = shape[i] * global.tile_size
		pieces[i].get_child(0).frame = color

func solidify(tilemap):
	for piece in pieces:
		var cell = tilemap.world_to_map(piece.global_position)
		tilemap.set_cellv(cell, color)
	queue_free()
