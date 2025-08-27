## Class that represent a keyboard.
extends Control

class_name Keyboard

## True if it's dragging.
var is_dragging: bool = false
## Drag offset since last frame.
var drag_offset: Vector2


## Connects buttons signals.
func _ready() -> void:
	_connect_buttons(self)


## Reset display text and makes itself invisible.
func reset() -> void:
	$Display/Label.set_text("Scrivi il numero")
	set_visible(false)


## Connects buttons "pressed" signal.
func _connect_buttons(node: Node) -> void:
	for child in node.get_children():
		if child is BaseButton and child != $CloseButton:
			child.connect("pressed", _on_button_pressed.bind(child))
		else:
			_connect_buttons(child)


## Return next display text when a button is pressed.
func _new_text(button_pressed: BaseButton) -> String:
	if button_pressed == $Backspace:
		return ""

	var text = $Display/Label.get_text()
	var replace = false

	if text == "" or text == "0" or text == "Scrivi il numero":
		replace = true

	if (int(text) <= 99 or text == "") and button_pressed != $Confirm:
		if replace:
			text = button_pressed.get_node("Text").get_text()
		else:
			text += button_pressed.get_node("Text").get_text()

	return text


## Called when a button is pressed. It updates display text.
func _on_button_pressed(button):
	$Display/Label.set_text(_new_text(button))


## Starts and make drag.
func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			drag_offset = get_global_mouse_position() - global_position
		else:
			is_dragging = false


## Every frame it drags.
func _process(_delta):
	if is_dragging:
		var mouse_pos = get_viewport().get_mouse_position() - drag_offset
		var screen_size = get_viewport_rect().size

		# Clamp la posizione per restare dentro lo schermo
		mouse_pos.x = clamp(mouse_pos.x, 0, screen_size.x - self.size.x)
		mouse_pos.y = clamp(mouse_pos.y, 0, screen_size.y - self.size.y)

		global_position = mouse_pos


## Enables typing from the keyboard.
func _unhandled_input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		var key_string = OS.get_keycode_string(event.keycode)
		if key_string.begins_with("Kp"):
			key_string = key_string.substr(3, 1)
		if key_string.is_valid_int():
			var index = key_string.to_int()
			var button_name = "Button" + str(index)
			var button_node = $ButtonsContainer.get_node(button_name)
			button_node.pressed.emit()
			button_node.toggle_mode = true
			button_node.set_pressed_no_signal(true)
			await get_tree().create_timer(0.2).timeout
			button_node.set_pressed_no_signal(false)
			button_node.toggle_mode = false


## Plays a sound when it becomes visible.
func _on_visibility_changed() -> void:
	if self.visible:
		AudioManager.popup()
