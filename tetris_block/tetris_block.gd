extends KinematicBody2D

const TetrisShapes = {
	A = [Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0), Vector2(0, 1)],
	S = [Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0), Vector2(2, 0)],
	D = [Vector2(0, 0), Vector2(1, 0), Vector2(0, 1), Vector2(1, 1)],
	C = [Vector2(-1, 1), Vector2(1, 0), Vector2(0, 1), Vector2(1, 1)],
	F = [Vector2(0, 0), Vector2(2, 1), Vector2(0, 1), Vector2(1, 1)],
	V = [Vector2(-1, 1), Vector2(0, 0), Vector2(1, 0), Vector2(0, 1)],
	G = [Vector2(-1, 0), Vector2(0, 1), Vector2(1, 1), Vector2(0, 0)],
}
const TileColors = [2, 3, 4, 5, 6]

onready var pieces = [$piece1, $piece2, $piece3, $piece4]

var fall_time_left = 0
var move_time_left = 0
var queued_movement = 0
var falls_left_to_live = INF

func _ready():
	pass

func _physics_process(delta):
	fall_time_left -= delta
	move_time_left -= delta
	
	if Input.is_action_just_pressed("rotate_tetris_left"):
		var new_transform = global_transform * Transform2D(-PI / 2, Vector2())
		if !test_move(new_transform, Vector2(0, 0.5) * global.tile_size):
			rotate_tetris(-1)
	if Input.is_action_just_pressed("rotate_tetris_right"):
		var new_transform = global_transform * Transform2D(PI / 2, Vector2())
		if !test_move(new_transform, Vector2(0, 0.5) * global.tile_size):
			rotate_tetris(1)
	
	if Input.is_action_just_pressed("move_tetris_left"):
		queued_movement = -1
	elif Input.is_action_pressed("move_tetris_left"):
		if queued_movement > 0: queued_movement = 0
		queued_movement -= 1 * delta
	
	if Input.is_action_just_pressed("move_tetris_right"):
		queued_movement = 1
	elif Input.is_action_pressed("move_tetris_right"):
		if queued_movement < 0: queued_movement = 0
		queued_movement += 1 * delta
	
	if move_time_left < 0:
		if abs(queued_movement) > 0.2:
			move_and_collide(Vector2(sign(queued_movement), 0) * global.tile_size)
			queued_movement = 0
		move_time_left = global.tile_size / global.tile_movement_speed
	
	if fall_time_left < 0:
		falls_left_to_live -= 1
		if falls_left_to_live <= 0:
			queue_free()
		
		var collision = move_and_collide(Vector2(0, 1) * global.tile_size)
		
		if Input.is_action_pressed("move_tetris_down"):
			fall_time_left += global.tile_size / global.tile_fast_falling_speed
		else:
			fall_time_left += global.tile_size / global.tile_falling_speed
			
		if collision != null:
			if collision.collider is TileMap:
				solidify(collision.collider)
			elif collision.collider.is_in_group("death"):
				queue_free()

func rotate_tetris(quaterturns):
	rotate(quaterturns * PI / 2)
	for piece in pieces:
		piece.rotate(- quaterturns * PI / 2)

func set_shape(shape):
	var color = TileColors[randi() % TileColors.size()]
	for i in pieces.size():
		pieces[i].position = shape[i] * global.tile_size
		pieces[i].get_child(0).frame = color

func solidify(tilemap):
	for piece in pieces:
		var cell = tilemap.world_to_map(piece.global_position)
		if tilemap.get_cellv(cell) == -1:
			tilemap.set_cellv(cell, piece.get_child(0).frame)
	queue_free()
