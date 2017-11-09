extends RigidBody2D



var State = {
	"Idle": 0,
	"Running": 1,
	"Dead": 2
}
var state = State.Idle

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	if( state == State.Running ):
		linear_velocity = Vector2(global.runner_speed)


func set_idle():
	state = State.Idle
func set_running():
	state = State.Running
func set_dead():
	state = State.Dead