extends KinematicBody

const MAX_TRAVEL_DIST: float = 14.0
const SPEED: float = 20.0
var direction: Vector3
var collided: bool = false
var distance_travelled: float = 0.0

func _ready():
	pass

func _process(delta):
	if not collided:
		var distance = SPEED * delta
		distance_travelled += distance
		if distance_travelled > MAX_TRAVEL_DIST:
			queue_free()
			distance -= distance_travelled - MAX_TRAVEL_DIST
		var collision = move_and_collide(direction * distance, false)
		if collision:
			# TODO maybe
			# if projectile hits the player, it stays in place were it hit the player
			# good would be, if it follows the player (get stuck inside the player)
			# the following code needs the correct calculation of the position/origin
			collided = true
			queue_free()
			if collision.collider.has_method("die"):
				collision.collider.die("projectile")
			#get_parent().remove_child(self)
			#collision.collider.add_child(self)
			#global_transform.origin = collision.collider.global_transform.origin - global_transform.origin
#			$Particles.emitting = false
#			collision_layer = 0
#			collision_mask = 0
