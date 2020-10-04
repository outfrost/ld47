extends Node

export var player_character: PackedScene
export var levels: Array

onready var level_container: Node = get_node(@"LevelContainer")
onready var menu: Control = get_node(@"MainMenu")

var current_level: int = -1
var level: Node

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	DebugLabel.display(self, "fps %d" % Performance.get_monitor(Performance.TIME_FPS))

	if level && Input.is_action_just_pressed("menu"):
		remove_level()
		menu.show()

func on_start_game() -> void:
	next_level()

func on_player_ded() -> void:
	spawn_player()

func on_level_finished() -> void:
	next_level()

func spawn_player() -> void:
	var spawn_point: Spatial = level.find_node("SpawnPoint")
	if !spawn_point:
		printerr("No player spawn point!!!")
		return
	var character: Spatial = player_character.instance()
	character.transform = spawn_point.global_transform
	character.connect("player_ded", self, "on_player_ded")
	level.add_child(character)

func next_level() -> void:
	call_deferred("remove_level")
	current_level = (current_level + 1) % levels.size()
	call_deferred("next_level_2")

func next_level_2() -> void:
	call_deferred("spawn_level")

func spawn_level() -> void:
	level = (levels[current_level] as PackedScene).instance()
	level_container.add_child(level)
	spawn_player()

func remove_level() -> void:
	for node in level_container.get_children():
		level_container.remove_child(node)
		(node as Node).queue_free()
