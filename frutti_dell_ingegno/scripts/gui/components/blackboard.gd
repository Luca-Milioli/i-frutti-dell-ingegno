extends VBoxContainer

class_name Blackboard

signal killed

func setup(system_equation : SystemEquation):
	for eq in system_equation.get_equations():
		var scene = preload("res://scenes/components/equation/equation_container.tscn").instantiate()
		scene.setup(eq)
		if eq == system_equation.get_equations()[-1]:
			scene.setup_last_one()
		add_child(scene)

func kill_children():
	for child in get_children():
		remove_child(child)
		child.queue_free()
	
func _on_custom_button_pressed() -> void:
	kill_children()
	killed.emit()
	
