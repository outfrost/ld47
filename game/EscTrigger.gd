extends Area

signal esc_trigger()

func _ready() -> void:
	connect("esc_trigger", get_tree().root.find_node("Game", true, false), "on_esc_trigger")
	connect("body_entered", self, "on_body_entered")

func on_body_entered(body: Node) -> void:
	if body.has_method("die"):
		emit_signal("esc_trigger")
