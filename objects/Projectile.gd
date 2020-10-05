extends KinematicBody

const MAX_TRAVEL_DIST: float = 14.0
const SPEED: float = 20.0
var direction: Vector3
var stopped: bool = false
var distance_travelled: float = 0.0

func _ready():
	pass

func _process(delta):
	if stopped:
		collision_layer = 0
		collision_mask = 0
		$MeshInstance.hide()
		$Particles.emitting = false
		yield(get_tree().create_timer(1.0), "timeout")
		queue_free()
	else:
		var distance = SPEED * delta
		distance_travelled += distance
		if distance_travelled > MAX_TRAVEL_DIST:
			stopped = true
			distance -= distance_travelled - MAX_TRAVEL_DIST
		var collision = move_and_collide(direction * distance, false)
		if collision:
			# TODO maybe
			# if projectile hits the player, it stays in place were it hit the player
			# good would be, if it follows the player (get stuck inside the player)
			# the following code needs the correct calculation of the position/origin
			stopped = true
			if collision.collider.has_method("die"):
				collision.collider.die("projectile")
			#get_parent().remove_child(self)
			#collision.collider.add_child(self)
			#global_transform.origin = collision.collider.global_transform.origin - global_transform.origin
