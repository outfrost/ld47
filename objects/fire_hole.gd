extends Spatial

var emitting: bool = false

func _ready():
	pass

func _on_Timer_timeout():
	emitting = not emitting
	$Fire.emitting = emitting
