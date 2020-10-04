extends Area

func _ready() -> void:
	connect("body_entered", self, "on_body_entered")

func on_body_entered(body: Node) -> void:
	if body.has_method("die"):
		body.die()
