class_name NarrativePopup
extends Popup

func display(msg: String, duration: float) -> void:
	$Panel/RichTextLabel.bbcode_text = msg
	show()
	yield(get_tree().create_timer(duration), "timeout")
	hide()
