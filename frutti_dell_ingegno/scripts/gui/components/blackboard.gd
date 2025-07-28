extends VBoxContainer

class_name Blackboard

signal killed


func setup(system_equation: SystemEquation):
	for eq in system_equation.get_equations():
		var scene = (
			preload("res://scenes/components/equation/equation_container.tscn").instantiate()
		)
		scene.setup(eq)
		if eq == system_equation.get_equations()[-1]:
			scene.setup_last_one()
		add_child(scene)


func kill_children():
	for child in get_children():
		remove_child(child)
		child.queue_free()


func first_animation():
	self.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)
	await tween.finished


func kill_animation() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished


func kill() -> void:
	await kill_animation()
	kill_children()
	killed.emit()


func _on_confirm_pressed() -> void:
	var text: StringName = $"../Keyboard/Display/Label".get_text()
	if text.is_valid_int():
		$FinalEquation/Rhs.set_text(text)
