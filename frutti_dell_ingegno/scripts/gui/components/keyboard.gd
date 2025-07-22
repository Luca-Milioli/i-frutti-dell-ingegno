extends Control

var is_dragging: bool = false
var drag_offset: Vector2

func _ready() -> void:
	_connect_buttons(self)

func reset():
	$Display/Label.set_text("Insert result...")
	
func _connect_buttons(node):
	for child in node.get_children():
		if child is Button:
			child.connect("pressed", _on_button_pressed.bind(child))
		else:
			_connect_buttons(child)

func _new_text(button_pressed) -> StringName:
	if button_pressed == $ButtonCancel:
		return ""
	
	var text = $Display/Label.get_text()
	var replace = false
		
	if (text == "" or text == "0" or text == "Insert result..."):
		replace = true
		
	if (int(text) <= 99 or text == "") and button_pressed != $Confirm:
		if replace:
			text = button_pressed.get_node("Text").get_text()
		else:
			text += button_pressed.get_node("Text").get_text()
	
	return text

func _on_button_pressed(button):
	$Display/Label.set_text(_new_text(button))

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			drag_offset = get_global_mouse_position() - global_position
		else:
			is_dragging = false

func _process(delta):
	if is_dragging:
		var mouse_pos = get_viewport().get_mouse_position() - drag_offset
		var screen_size = get_viewport_rect().size
		
		# Clamp la posizione per restare dentro lo schermo
		mouse_pos.x = clamp(mouse_pos.x, 0, screen_size.x - self.size.x)
		mouse_pos.y = clamp(mouse_pos.y, 0, screen_size.y - self.size.y)

		global_position = mouse_pos
