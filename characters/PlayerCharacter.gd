extends KinematicBody

signal player_ded(reason)

export var speed: float = 4.0
export var lateral_acceleration: float = 15.0
export var jump_speed: float = 5.5
export var death_height: float = 3.2

onready var camera: Camera = get_tree().root.find_node("Camera", true, false)
onready var last_elev: float = global_transform.origin.y

var dead: bool = false
var controllable: bool = true
var x_velocity: float = 0
var y_velocity: float = 0
var airborne: bool = true

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if dead:
		return

	var target_camera_pos = self.global_transform.origin + Vector3(3.0, 2.0, 10.0)
	camera.translation = lerp(camera.translation, target_camera_pos, clamp(delta * 4.0, 0.0, 1.0))

	if controllable && Input.is_action_just_pressed("kill"):
		die("suicide")

	if !is_on_floor():
		y_velocity -= 9.8 * delta
		move_and_slide(Vector3.UP * y_velocity, Vector3.UP, false, 4, 0.5)
		if is_on_floor():
			y_velocity = 0.0
			airborne = false
		else:
			airborne = true
	
	if !airborne:
		if last_elev - global_transform.origin.y > death_height:
			die("fall")
		last_elev = global_transform.origin.y

	move_and_slide(Vector3.RIGHT * x_velocity, Vector3.UP, false, 4, 0.5)

	var x_target_velocity
	if controllable:
		if !airborne && Input.is_action_just_pressed("jump"):
			y_velocity = jump_speed
			move_and_slide(Vector3.UP * y_velocity, Vector3.UP, false, 4, 0.5)

		x_target_velocity = (
			(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
			* speed
		)
	else:
		x_target_velocity = 0.0

	var diff = x_target_velocity - x_velocity
	var accel = lateral_acceleration * delta
	x_velocity += min(abs(diff), abs(accel)) * sign(diff)
	x_velocity = clamp(x_velocity, - speed, speed)

#	# Horizontal movement code. First, get the player's input.
#	var walk = WALK_FORCE * (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
#	# Slow down the player if they're not trying to move.
#	if abs(walk) < WALK_FORCE * 0.2:
#		# The velocity, slowed down a bit, and then reassigned.
#		velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
#	else:
#		velocity.x += walk * delta
#	# Clamp to the maximum horizontal movement speed.
#	velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)
#
#	# Vertical movement code. Apply gravity.
#	velocity.y += gravity * delta
#
#	# Move based on the velocity and snap to the ground.
#	velocity = move_and_slide_with_snap(velocity, Vector3.DOWN, Vector3.UP)
#
#	# Check for jumping. is_on_floor() must be called after movement code.
#	if is_on_floor() and Input.is_action_just_pressed("jump"):
#		velocity.y = JUMP_SPEED

func die(reason: String) -> void:
	if !controllable:
		return
	rotate_z(TAU / 4.0)
	controllable = false
	yield(get_tree().create_timer(2.0), "timeout")
	dead = true
	emit_signal("player_ded", reason)
