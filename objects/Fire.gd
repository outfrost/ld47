extends Spatial

var emitting: bool = false
var character: Node

func _ready():
	pass

func _process(delta):
	$Particles.emitting = emitting
	$Light.visible = emitting
	if emitting and character and !character.dead:
		$AudioStreamPlayer3D.play()
		character.die("fire")
		character = null

func _on_Area_body_entered(body):
	if body is PlayerCharacter and !body.dead:
		character = body

func _on_Area_body_exited(body: Node) -> void:
	if body is PlayerCharacter and !body.dead:
		character = null
