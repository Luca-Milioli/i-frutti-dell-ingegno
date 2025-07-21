extends Control


func _ready() -> void:
	_connect_buttons(self)

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
		
	if int(text) <= 99 or text == "":
		if replace:
			text = button_pressed.get_node("Text").get_text()
		else:
			text += button_pressed.get_node("Text").get_text()
	
	return text
	
func _on_button_pressed(button):
	$Display/Label.set_text(_new_text(button))
