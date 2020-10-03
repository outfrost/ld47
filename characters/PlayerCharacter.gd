extends KinematicBody

export var speed: float = 4.0
export var jump_speed: float = 5.5

onready var camera: Camera = get_tree().root.find_node("Camera", true, false)

var dead = false
var y_velocity: float = 0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if dead:
		return

	var target_camera_pos = self.global_transform.origin + Vector3(3.0, 2.0, 10.0)
	camera.translation = lerp(camera.translation, target_camera_pos, delta)

func _physics_process(delta: float) -> void:
	if dead:
		return

	if !is_on_floor():
		y_velocity -= 9.8 * delta
		move_and_slide(Vector3.UP * y_velocity, Vector3.UP, false, 4, 0.5)
		if is_on_floor():
			y_velocity = 0.0
	
	if is_on_floor() && Input.is_action_just_pressed("jump"):
		y_velocity = jump_speed
		move_and_slide(Vector3.UP * y_velocity, Vector3.UP, false, 4, 0.5)

	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_left"):
		direction += Vector3.LEFT
	if Input.is_action_pressed("move_right"):
		direction += Vector3.RIGHT
	direction = direction.normalized()
	move_and_slide(direction * speed, Vector3.UP, false, 4, 0.5)
