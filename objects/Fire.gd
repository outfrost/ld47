extends Spatial

var emitting: bool = false

func _ready():
	pass

func _process(delta):
	$Particles.emitting = emitting
	$Light.visible = emitting


func _on_Area_body_entered(body):
	if body.has_method("die") and emitting:
		body.die()
