class_name NarrativePopup
extends Popup

const TIME_PER_CHAR: float = 0.03

onready var label = $Panel/RichTextLabel

var time_displayed: float = 0.0
var duration: float = 0.0

func _process(delta: float) -> void:
	if !visible:
		return
	time_displayed += delta
	if time_displayed > duration:
		hide()
	label.visible_characters = time_displayed / TIME_PER_CHAR

func display(msg: String, dur: float) -> void:
	duration = dur
	time_displayed = 0.0
	label.bbcode_text = msg
	label.visible_characters = 0
	show()
