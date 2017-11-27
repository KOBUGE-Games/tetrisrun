extends Reference

const MAX_HEIGHT = 16

var reached_position = 0
var last_heights_ringbuffer = PoolIntArray([])
var last_heights_position = 0

func _init():
	initialize_buffer(10)

func generate_height():
	var height = clamp(get_previous_height(1) + randi() % 3 - 1, 0, MAX_HEIGHT)
	height = get_previous_height(1)
	write_height(height)
	return height


func initialize_buffer(size):
	last_heights_ringbuffer.resize(10)
	for i in range(last_heights_ringbuffer.size()):
		last_heights_ringbuffer[i] = 3

func get_previous_height(offset):
	assert(offset < last_heights_ringbuffer.size())
	return last_heights_ringbuffer[last_heights_position - offset]

func write_height(height):
	last_heights_ringbuffer[last_heights_position] = height
	last_heights_position = (last_heights_position + 1) % last_heights_ringbuffer.size()
	reached_position += 1

