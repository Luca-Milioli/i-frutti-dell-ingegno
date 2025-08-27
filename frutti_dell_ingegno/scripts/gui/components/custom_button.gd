## Class that extends the BaseButton and represents a BaseButton with tap sound on press.
extends BaseButton
class_name CustomButton


## Plays the tap audio when the button is pressed.
func _on_pressed() -> void:
	AudioManager.tap()


## Fades in.
func _on_visibility_changed() -> void:
	if self.visible:
		Utils.recursive_disable_buttons(self, false)

		self.modulate.a = 0
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 1.0, 0.5)


## Fades out.
func fade_out() -> void:
	Utils.recursive_disable_buttons(self, true)

	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	self.visible = false
