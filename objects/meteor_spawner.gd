extends Spatial

var meteor = preload("res://objects/Meteor.tscn")

func _ready():
	pass

func _on_Timer_timeout():
	var m = meteor.instance()
	m.transform = transform
	m.direction = Vector3(randf() * 10, -1.0, 0.0) - global_transform.origin
	get_parent().add_child(m)
