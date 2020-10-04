extends Area

signal level_finished()

func _ready() -> void:
	connect("level_finished", get_tree().root.find_node("Game", true, false), "on_level_finished")
	connect("body_entered", self, "on_body_entered")

func on_body_entered(body: Node) -> void:
	if body.has_method("die"):
		emit_signal("level_finished")
