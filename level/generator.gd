extends Reference

const MAX_HEIGHT = 8 # 16

var reached_position = 0
var last_heights_ringbuffer = PoolIntArray([])
var last_heights_position = 0

func _init():
	initialize_buffer(10)

func generate_height():
	var target_difficulty = ((reached_position + 50) / 40.0)
	var best_height = -1
	var best_difficulty_difference = INF
	for height in range(-1, MAX_HEIGHT): if height != 0:
		write_height(height, false)
		var difficulty = estimate_hole_difficulty() * (1 + randf() * 0.1)
		if abs(target_difficulty - difficulty) < best_difficulty_difference:
			best_difficulty_difference = abs(target_difficulty - difficulty)
			best_height = height
	write_height(best_height)
	return best_height

func estimate_hole_difficulty():
	var window_size = 8
	var hole_size = 0
	var climb_before_hole = 1
	var climb_after_hole = 1
	var climb_during_hole = -1
	var hole_start = -1
	for i in range(window_size): # NOTE: going backward in history as i increases
		if get_previous_height(i) == -1:
			hole_size += 1
			if hole_start == -1: hole_start = i
		elif hole_start == -1:
			climb_after_hole *= get_climb_difficulty(i)
		else:
			if climb_during_hole == -1 and hole_start != 0:
				climb_during_hole = get_climb_difficulty(hole_start - 1, i)
			climb_before_hole *= get_climb_difficulty(i)
	
	climb_after_hole = pow(climb_after_hole, 9 / window_size)
	climb_before_hole = pow(climb_before_hole, 9 / window_size)
	hole_size = clamp(hole_size - 0.5, 0, 1)
	var total_difficulty = climb_after_hole * climb_before_hole
	if climb_during_hole != -1:
		total_difficulty *= climb_during_hole
		total_difficulty *= exp(hole_size)
	
	return total_difficulty

func get_climb_difficulty(from_offset, to_offset=from_offset-1):
	if to_offset < 0 or get_previous_height(from_offset) == -1 or get_previous_height(to_offset) == -1:
		return 1
	
	var difference = get_previous_height(to_offset) - get_previous_height(from_offset)
	
	if difference <= 1: # Fall
		return abs(difference) / 2 + 1
	else:
		return difference * difference + 1

func initialize_buffer(size):
	last_heights_ringbuffer.resize(10)
	for i in range(last_heights_ringbuffer.size()):
		last_heights_ringbuffer[i] = 3

func get_previous_height(offset):
	assert(offset < last_heights_ringbuffer.size())
	return last_heights_ringbuffer[last_heights_position - offset]

func write_height(height, move=true):
	last_heights_ringbuffer[last_heights_position] = height
	if move:
		last_heights_position = (last_heights_position + 1) % last_heights_ringbuffer.size()
		reached_position += 1

