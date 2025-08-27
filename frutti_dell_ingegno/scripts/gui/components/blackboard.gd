## Class that represent the view of a blackboard. It shows whole the system.
extends VBoxContainer
class_name Blackboard

## Emiited when it fades out.
signal killed
## Emitted when an equation_container is added as a child.
signal children_appaered


## Given the SystemEquation, it creates a EquationContainer for each equation and adds
## it as a child.
func setup(system_equation: SystemEquation):
	for eq in system_equation.get_equations():
		var scene = (
			preload("res://scenes/components/equation/equation_container.tscn").instantiate()
		)
		scene.setup(eq)
		if eq == system_equation.get_equations()[-1]:
			scene.setup_last_one()
			add_child(scene)
			await scene.tween_finished
			self.children_appaered.emit()
		else:
			add_child(scene)


## Removes and frees every EquationContainer.
func kill_children():
	for child in get_children():
		remove_child(child)
		child.queue_free()


## Fades itself in.
func first_animation():
	self.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)
	await tween.finished


## Fades itself out.
func kill_animation() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished


## Fades itself out and removes his children. Emits killed signal.
func kill() -> void:
	await kill_animation()
	kill_children()
	killed.emit()
