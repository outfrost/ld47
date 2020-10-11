extends Node

export var player_character: PackedScene
export var levels: Array

onready var level_container: Node = get_node(@"LevelContainer")
onready var menu: Control = get_node(@"MainMenu")
onready var narrative_popup: NarrativePopup = get_node(@"NarrativePopup")
onready var death_ct_label: RichTextLabel = get_node(@"DeathCtLabel")

var current_level: int = 0
var level: Node
var character: Spatial

var death_ct: int = 0
var total_death_ct: int = 0
var fall_death_ct: int = 0
var fire_death_ct: int = 0
var spikes_death_ct: int = 0
var projectile_death_ct: int = 0
var said_grilling_shashlik: bool = false
var said_esc_trigger: bool = false
var awaiting_esc_comeback: bool = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	DebugLabel.display(self, "fps %d" % Performance.get_monitor(Performance.TIME_FPS))

	if level && Input.is_action_just_pressed("menu"):
		back_to_menu()

	if level && Input.is_action_just_pressed("next_level"):
		next_level()

func on_start_game() -> void:
	current_level -= 1
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
							character.controllable = false
							narrative_popup.display("Oh wow, you actually jumped."
								+ " Honestly, I wasn’t expecting you to.", 4.0)
							yield(get_tree().create_timer(4.0), "timeout")
							var offset = character.camera_offset
							character.camera_offset += Vector3(3.0, -6.0, 0.0)
							narrative_popup.display("Well anyways, you probably noticed"
								+ " that your body is down there but you’re still up here.", 7.0)
							yield(get_tree().create_timer(7.0), "timeout")
							character.camera_offset = offset
							character.controllable = true
							narrative_popup.display("Now, if you use your brain [i]really[/i] hard,"
								+ " you might think of a use for this strange phenomenon.", 10.0)
						3:
							narrative_popup.display("I know you can figure this out."
								+ " Probably.", 5.0)
						5:
							narrative_popup.display("Now that you know how to fall, try jumping."
								+ " It's [Space], [W] or [↑].", 8.0)
						7:
							narrative_popup.display("If you get stuck, you can always just die on the spot."
								+ " Feel free to press [F] or [Enter].", 7.0)
							yield(get_tree().create_timer(7.0), "timeout")
							narrative_popup.display("I won't be paying respects, though.", 4.0)
						9:
							narrative_popup.display("You seem to be dying a lot."
								+ " Don’t worry, I’ve got your back.", 4.0)
							yield(get_tree().create_timer(4.0), "timeout")
							death_ct_label.show()
							narrative_popup.display("I’ll put up a counter for you."
								+ " That should make you do better.", 6.0)
						11:
							narrative_popup.display("I forgot to ask. Are you afraid of heights?", 5.0)
						16:
							narrative_popup.display("Cool. A bonsai of dead bodies.", 5.0)
						19:
							narrative_popup.display("What a sad pile.", 3.0)
						23:
							narrative_popup.display("Do you enjoy failing like this?", 4.0)
				"spikes":
					spikes_death_ct += 1
					match spikes_death_ct:
						1:
							narrative_popup.display("I can't believe you just walked into that.", 5.0)
							yield(get_tree().create_timer(5.0), "timeout")
							narrative_popup.display("That was pretty dumb.", 2.0)
						2:
							narrative_popup.display("Are you trying to make a human shashlik?", 5.0)
						4:
							narrative_popup.display("Wow, again?", 3.0)
						6:
							narrative_popup.display("Ouch.", 2.0)
						9:
							narrative_popup.display("Do you need a hand? I see yours got chopped off.", 6.0)
						12:
							narrative_popup.display("How many stabs are you gonna take"
								+ " just to move a few metres forward?", 8.0)
				"fire":
					fire_death_ct += 1
					match fire_death_ct:
						1:
							continue
						2:
							if !said_grilling_shashlik && spikes_death_ct >= 2:
								narrative_popup.display("Ah, time to grill the shashlik.", 5.0)
								said_grilling_shashlik = true
						3:
							narrative_popup.display("Toasty.", 2.0)
						4:
							narrative_popup.display("Did noone teach you that fire burns?", 4.0)
						5:
							if !said_grilling_shashlik && spikes_death_ct >= 2:
								narrative_popup.display("Ah, time to grill the shashlik.", 5.0)
								said_grilling_shashlik = true
						6:
							narrative_popup.display("Pretty sure going down in flames is not the objective here.", 6.0)
						10:
							narrative_popup.display("That's becoming an impressive pile of crisps.", 5.0)
						14:
							narrative_popup.display("I don't know what I expected.", 4.0)
		1:
			match reason:
				"fall":
					fall_death_ct += 1
					match fall_death_ct:
						11:
							narrative_popup.display("I forgot to ask. Are you afraid of heights?", 5.0)
						16:
							narrative_popup.display("Cool. A bonsai of dead bodies.", 5.0)
						19:
							narrative_popup.display("What a sad pile.", 3.0)
						23:
							narrative_popup.display("Do you enjoy failing like this?", 4.0)
				"spikes":
					spikes_death_ct += 1
					match spikes_death_ct:
						4:
							narrative_popup.display("Wow, again?", 3.0)
						6:
							narrative_popup.display("Ouch.", 2.0)
						12:
							narrative_popup.display("How many stabs are you gonna take"
								+ " just to move a few metres forward?", 8.0)
				"fire":
					fire_death_ct += 1
					match fire_death_ct:
						1:
							continue
						2:
							if !said_grilling_shashlik && spikes_death_ct >= 2:
								narrative_popup.display("Ah, time to grill the shashlik.", 5.0)
								said_grilling_shashlik = true
						3:
							narrative_popup.display("Toasty.", 2.0)
						4:
							narrative_popup.display("Did noone teach you that fire burns?", 4.0)
						5:
							if !said_grilling_shashlik && spikes_death_ct >= 2:
								narrative_popup.display("Ah, time to grill the shashlik.", 5.0)
								said_grilling_shashlik = true
						6:
							narrative_popup.display("Pretty sure going down in flames is not the objective here.", 6.0)
						10:
							narrative_popup.display("That's becoming an impressive pile of crisps.", 5.0)
						14:
							narrative_popup.display("I don't know what I expected.", 4.0)
				"projectile":
					projectile_death_ct += 1
					match projectile_death_ct:
						1:
							narrative_popup.display("Ah, here we go. You're gonna eat hot plasma now?", 5.0)
						3:
							narrative_popup.display("Pretty sure you're supposed to avoid those.", 5.0)
						5:
							narrative_popup.display("Not only will this kill you,"
								+ " it will hurt the entire time you're dying.", 7.0)
							yield(get_tree().create_timer(7.0), "timeout")
							narrative_popup.display("Luckily for you that's about a second."
								+ " Every time.", 6.0)
						7:
							narrative_popup.display("You're not doing great.", 4.0)
						9:
							narrative_popup.display("You took that one to the face, didn't you.", 5.0)
						11:
							narrative_popup.display("That's pretty pathetic.", 4.0)
						13:
							narrative_popup.display("See, if you stop eating those,"
								+ " maybe you'll make it a little further.", 7.0)
						15:
							narrative_popup.display("My grandma dodged bullets better in '44,"
								+ " and they flew way faster.", 7.0)

func on_level_finished() -> void:
	awaiting_esc_comeback = false
	next_level()

func on_game_finished() -> void:
	yield(get_tree().create_timer(4.0), "timeout")
	narrative_popup.display("Well look at you.", 3.0)
	yield(get_tree().create_timer(3.0), "timeout")
	narrative_popup.display("You actually did it.", 4.0)
	yield(get_tree().create_timer(4.0), "timeout")
	death_ct_label.bbcode_text = "Total deaths: %d" % total_death_ct
	death_ct_label.show()
	$DeathCtPanel.show()
	narrative_popup.display("All of that pain and misery has brought you here."
		+ " Into this blank void.", 7.0)
	yield(get_tree().create_timer(7.0), "timeout")
	narrative_popup.display("[i]\"What now\"[/i], you ask?", 4.0)
	yield(get_tree().create_timer(4.0), "timeout")
	narrative_popup.display("There was never a plan for anything.", 3.0)
	yield(get_tree().create_timer(3.0), "timeout")
	narrative_popup.display("Anyway, I've got a train to catch. Farewell.", 4.0)
	yield(get_tree().create_timer(5.0), "timeout")
	current_level = (current_level + 1) % levels.size()
	back_to_menu()

func on_esc_trigger() -> void:
	if !said_esc_trigger:
		narrative_popup.display("Hey, press [Esc] and see what happens.", 6.0)
		said_esc_trigger = true
		awaiting_esc_comeback = true

func back_to_menu() -> void:
	remove_level()
	narrative_popup.hide()
	death_ct_label.hide()
	$DeathCtPanel.hide()
	menu.show()

func spawn_player() -> void:
	var spawn_point: Spatial = level.find_node("SpawnPoint")
	if !spawn_point:
		printerr("No player spawn point!!!")
		return
	character = player_character.instance()
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
	character.controllable = false
	total_death_ct += death_ct 
	death_ct = 0
	death_ct_label.bbcode_text = "Deaths: %d" % death_ct
	if awaiting_esc_comeback:
		narrative_popup.display("Oh, haha, you fell for that?", 5.0)
		yield(get_tree().create_timer(5.0), "timeout")
		narrative_popup.display("It's easy to get you to do things. Even dumb ones.", 6.0)
		awaiting_esc_comeback = false
		character.controllable = true
		if fall_death_ct >= 9:
			death_ct_label.show()
		return
	match current_level:
		0:
			death_ct_label.hide() # Hide label in case we circle back
			$DeathCtPanel.hide()
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
			narrative_popup.display("Well, you gotta find an exit.", 4.0)
			yield(get_tree().create_timer(4.0), "timeout")
			narrative_popup.display("If you haven't figured, it's [A] and [D] or [←] and [→] to move.", 6.0)
			yield(get_tree().create_timer(6.0), "timeout")
			character.controllable = true
			narrative_popup.display("See that ledge in front of you? Jump off of it.", 6.0)
		1:
			death_ct_label.show() # This will show the death count label in case we skip the first level before completing the tutorial
			yield(get_tree().create_timer(0.5), "timeout")
			narrative_popup.display("Geez, finally. Did it have to take so long?", 5.0)
			yield(get_tree().create_timer(5.0), "timeout")
			narrative_popup.display("Well, it does seem like this corridor leads somewhere.", 6.0)
			yield(get_tree().create_timer(6.0), "timeout")
			character.controllable = true
			narrative_popup.display("Might as well find out where.", 4.0)
		2:
			death_ct_label.show() # This will show the death count label in case we skip the first level before completing the tutorial
			character.controllable = true

func remove_level() -> void:
	for node in level_container.get_children():
		level_container.remove_child(node)
		(node as Node).queue_free()
