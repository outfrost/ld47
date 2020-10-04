extends KinematicBody

const MAX_LIFE_TIME: float = 1.0
const SPEED: float = 20.0
var direction: Vector3
var life_time: float = 0
var collided: bool = false

func _ready():
	pass

func _process(delta):
	if not collided:
		var collision = move_and_collide(delta * direction * SPEED, false)
		if collision:
			# TODO:
			# if projectile hits the player, it stays in place were it hit the player
			# good would be, if it follows the player (get stuck inside the player)
			# the following code needs the correct calculation of the position/origin
			#get_parent().remove_child(self)
			#collision.collider.add_child(self)
			#global_transform.origin = collision.collider.global_transform.origin - global_transform.origin
			life_time = 0
			collided = true
			$Particles.emitting = false
	else:
		life_time += delta
		if life_time > MAX_LIFE_TIME:
			queue_free()
