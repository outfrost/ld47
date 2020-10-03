extends Node

export var player_character: PackedScene
export var levels: Array

onready var level_container: Node = get_node(@"LevelContainer")
onready var menu: Control = get_node(@"MainMenu")

var current_level: int = 0
var level: Node

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if level && Input.is_action_just_pressed("menu"):
		remove_level()
		menu.show()

func on_start_game() -> void:
	next_level()

func spawn_player() -> void:
	var spawn_point: Spatial = level.find_node("SpawnPoint")
	if !spawn_point:
		printerr("No player spawn point!!!")
		return
	var character: Spatial = player_character.instance()
	character.transform = spawn_point.global_transform
	level.add_child(character)

func next_level() -> void:
	remove_level()
	current_level = (current_level + 1) % levels.size()
	call_deferred("spawn_level")

func spawn_level() -> void:
	level = (levels[current_level] as PackedScene).instance()
	level_container.add_child(level)
	spawn_player()

func remove_level() -> void:
	for node in level_container.get_children():
		level_container.remove_child(node)
		(node as Node).queue_free()
