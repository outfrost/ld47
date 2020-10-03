extends Popup

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and !event.pressed:
			hide()
