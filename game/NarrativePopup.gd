class_name NarrativePopup
extends Popup

const TIME_PER_CHAR: float = 0.03

var time_displayed: float = 0.0
var duration: float = 0.0
var message: String

func _process(delta: float) -> void:
	if !visible:
		return
	time_displayed += delta
	if time_displayed > duration:
		hide()
	$Panel/RichTextLabel.bbcode_text = message.substr(0, time_displayed / TIME_PER_CHAR)

func display(msg: String, dur: float) -> void:
	message = msg
	duration = dur
	time_displayed = 0.0
	$Panel/RichTextLabel.bbcode_text = ""
	show()
