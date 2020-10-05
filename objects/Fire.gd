extends Spatial

var emitting: bool = false
var character: Node

func _ready():
	pass

func _process(delta):
	$Particles.emitting = emitting
	$Light.visible = emitting
	if character and emitting:
		$AudioStreamPlayer3D.play()
		character.die("fire")

func _on_Area_body_entered(body):
	if body.has_method("die"):
		character = body

func _on_Area_body_exited(body: Node) -> void:
	if body == character:
		character = null
