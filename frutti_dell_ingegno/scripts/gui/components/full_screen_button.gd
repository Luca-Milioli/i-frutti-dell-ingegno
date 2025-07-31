extends TextureButton


func _ready() -> void:
	if not is_fullscreen_available():
		self.queue_free()


func is_fullscreen_available() -> bool:
	if OS.has_feature("debug"):
		return false
	return true


func _toggle_fullscreen() -> bool:  # return ture if it sets fullscreen
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		return false
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	return true


func _on_pressed() -> void:
	_toggle_fullscreen()
