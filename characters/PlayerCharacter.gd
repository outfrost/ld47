extends KinematicBody

onready var camera: Camera = get_tree().root.find_node("Camera", true, false)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var target_camera_pos = self.global_transform.origin + Vector3(3.0, 2.0, 10.0)
	camera.translation = lerp(camera.translation, target_camera_pos, delta)
#	DebugLabel.display(self, String(camera.translation))
