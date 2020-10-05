extends Spatial

var projectile = preload("res://objects/Projectile.tscn")

func _ready():
	yield(get_tree().create_timer(0.2), "timeout")
	_on_Timer_timeout()

func _on_Timer_timeout():
	var p = projectile.instance()
	p.transform = transform
	p.direction = ($Aim.global_transform.origin - $MeshInstance.global_transform.origin).normalized()
	get_parent().add_child(p)
