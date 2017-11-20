extends RigidBody2D

enum State {
	Idle,
	Running,
	Dead,
}
var state = State.Idle
onready var floor_ray = $floor_ray

func _ready():
	set_running()

func _integrate_forces(forces):
	if state == State.Running:
		var velocity = forces.get_linear_velocity()
		velocity.x = global.runner_speed
		
		if Input.is_action_pressed("jump") and floor_ray.is_colliding():
			velocity.y = -global.runner_jump
		
		forces.set_linear_velocity(velocity)


func set_idle():
	state = State.Idle
	$animation_player.play("idle")

func set_running():
	state = State.Running
	set_sleeping(false)
	$animation_player.play("run")

func set_dead():
	state = State.Dead
	$animation_player.play("idle") # TODO