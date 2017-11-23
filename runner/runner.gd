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
		
		for contact in forces.get_contact_count():
			if forces.get_contact_collider_object(contact).is_in_group("death"):
				set_dead()
		
		$gui/screen/label.text = "%0*.1f m" % [10, position.x / global.tile_size]


func set_idle():
	state = State.Idle
	$animation_player.play("idle")

func set_running():
	state = State.Running
	set_sleeping(false)
	$animation_player.play("run")

func set_dead():
	state = State.Dead
	collision_mask = 0
	collision_layer = 0
	linear_damp = 2
	$animation_player.play("idle") # TODO