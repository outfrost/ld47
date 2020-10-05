extends Spatial

var projectile = preload("res://objects/Projectile.tscn")

func _ready():
	pass

func _on_Timer_timeout():
	var p = projectile.instance()
	p.transform = transform
	p.direction = ($Aim.global_transform.origin - $MeshInstance.global_transform.origin).normalized()
	get_parent().add_child(p)
