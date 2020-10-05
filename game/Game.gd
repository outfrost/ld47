extends Node

export var player_character: PackedScene
export var levels: Array

onready var level_container: Node = get_node(@"LevelContainer")
onready var menu: Control = get_node(@"MainMenu")
onready var narrative_popup: NarrativePopup = get_node(@"NarrativePopup")
onready var death_ct_label: RichTextLabel = get_node(@"DeathCtLabel")

var current_level: int = -1
var level: Node

var death_ct: int = 0
var total_death_ct: int = 0
var fall_death_ct: int = 0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	DebugLabel.display(self, "fps %d" % Performance.get_monitor(Performance.TIME_FPS))

	if level && Input.is_action_just_pressed("menu"):
		back_to_menu()

	if level && Input.is_action_just_pressed("next_level"):
		next_level()

func on_start_game() -> void:
	current_level = -1
	next_level()

func on_player_ded(reason: String) -> void:
	death_ct += 1
	death_ct_label.bbcode_text = "Deaths: %d" % death_ct
	spawn_player()
	match current_level:
		0:
			match reason:
				"fall":
					fall_death_ct += 1
					match fall_death_ct:
						1:
							narrative_popup.display("Oh wow, you actually jumped."
								+ " Honestly, I wasn’t expecting you to.", 4.0)
							yield(get_tree().create_timer(4.0), "timeout")
							narrative_popup.display("Well anyways, you probably noticed"
								+ " that your body is down there but you’re still up here.", 6.0)
							yield(get_tree().create_timer(6.0), "timeout")
							narrative_popup.display("Now, if you use your brain [i]really[/i] hard,"
								+ " you might think of a use for this strange phenomenon.", 8.0)
#							yield(get_tree().create_timer(8.0), "timeout")
						8:
							narrative_popup.display("You seem to be dying a lot."
								+ " Don’t worry, I’ve got your back.", 4.0)
							yield(get_tree().create_timer(4.0), "timeout")
							death_ct_label.show()
							narrative_popup.display("I’ll put up a counter for you."
								+ " That should make you do better.", 5.0)
#							yield(get_tree().create_timer(5.0), "timeout")

func on_level_finished() -> void:
	next_level()

func back_to_menu() -> void:
	remove_level()
	narrative_popup.hide()
	death_ct_label.hide()
	menu.show()

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
	total_death_ct += death_ct 
	death_ct = 0
	match current_level:
		0:
			yield(get_tree().create_timer(2.0), "timeout")
			narrative_popup.display("Oh, hey there.", 4.0)
			yield(get_tree().create_timer(4.0), "timeout")
			narrative_popup.display("Are you lost?", 4.0)
			yield(get_tree().create_timer(4.0), "timeout")
			narrative_popup.display("I didn't expect to find you here."
				+ " You probably want to get out of here, don't you?", 8.0)
			yield(get_tree().create_timer(8.0), "timeout")
			narrative_popup.display("Who would want to stay in this place, anyway.", 4.0)
			yield(get_tree().create_timer(5.0), "timeout")
			narrative_popup.display("Well, you gotta find an exit.", 3.0)
			yield(get_tree().create_timer(3.0), "timeout")
			narrative_popup.display("If you haven't realised yet, it's [A] and [D] or [←] and [→] to move.", 6.0)
			yield(get_tree().create_timer(6.0), "timeout")
			narrative_popup.display("See that ledge in front of you? Jump off of it.", 6.0)
#			yield(get_tree().create_timer(6.0), "timeout")

func remove_level() -> void:
	for node in level_container.get_children():
		level_container.remove_child(node)
		(node as Node).queue_free()
