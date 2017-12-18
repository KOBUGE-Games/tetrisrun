extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_start_endless_button_pressed():
	get_tree().change_scene_to(load("res://level/infinite_level.tscn"))


func _on_start_fixed_button_pressed():
	get_tree().change_scene_to(load("res://level/fixed_level.tscn"))


func _on_options_button_pressed():
	pass # replace with function body


func _on_exit_button_pressed():
	get_tree().quit()
