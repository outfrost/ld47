extends KinematicBody

var original_rotation: Vector3 = rotation
var direction: Vector3 = Vector3(-1, -1, 0)
const SPEED: float = 0.5

func _ready():
	pass

func _physics_process(delta):
	# TODO:
	# set the correction rotation
	# rotation = direction ?
	var collision = move_and_collide(delta * direction * SPEED)
	if collision:
		set_physics_process(false)
		if collision.collider.has_method("die"):
			collision.collider.die("meteor")
		collision_layer = 0
		collision_mask = 0
		$MeshInstance.visible = false
		$Particles.visible = false
		rotation = original_rotation
		$Explosion.visible = true
		$Timer.start()

func _on_Timer_timeout():
	if $Explosion.emitting:
		$Explosion.emitting = false
	else:
		queue_free()
