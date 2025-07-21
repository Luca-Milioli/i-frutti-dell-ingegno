extends Control


func _ready() -> void:
	_connect_buttons(self)

func _connect_buttons(node):
	for child in node.get_children():
		if child is Button:
			child.connect("pressed", _on_button_pressed.bind(child))
		else:
			_connect_buttons(child)

func _on_button_pressed(button):
	print(button.get_node("Text").get_text())
