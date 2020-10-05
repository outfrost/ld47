extends Popup

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		hide()

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and !event.pressed:
			hide()
