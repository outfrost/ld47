extends Area

signal game_finished()

var time_since_finished: float = 0.0
var finished: float = false
onready var mat: SpatialMaterial = $MeshInstance.mesh.surface_get_material(0).duplicate()

func _ready() -> void:
	connect("game_finished", get_tree().root.find_node("Game", true, false), "on_game_finished")
	connect("body_entered", self, "on_body_entered")
	$MeshInstance.mesh.surface_set_material(0, mat)

func _process(delta: float) -> void:
	if finished:
		time_since_finished += delta
		$DirectionalLight.light_energy = time_since_finished * 4.0
		mat.albedo_color = Color(1.0, 1.0, 1.0, time_since_finished * 0.25)

func on_body_entered(body: Node) -> void:
	if body.has_method("die"):
		finished = true
		emit_signal("game_finished")
