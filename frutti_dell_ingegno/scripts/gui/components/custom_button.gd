extends BaseButton


func _on_pressed() -> void:
	AudioManager.tap()


func _on_visibility_changed() -> void:
	if self.visible:
		self.modulate.a = 0
		Utils.recursive_disable_buttons(self, false)
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 1.0, 0.5)


func fade_out() -> void:
	Utils.recursive_disable_buttons(self, true)

	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	self.visible = false
