## Class that represent a view container for an equation.
extends HBoxContainer

class_name EquationContainer

## Emitted when animations are finished.
signal tween_finished

## Path to directory where .png of fruits are saved.
const PATH_TO_FRUIT = "res://art/graphics/fruit/"
## Path to directory where .png of signs are saved.
const PATH_TO_SIGN = "res://art/graphics/signs/"
## Path to directory where equation-related scenes are saved.
const PATH_TO_SCENES = "res://scenes/components/equation/"

## The equation that this object contains.
var _equation: Equation


## Getter for _equation.
func get_equation() -> Equation:
	return self._equation


## Inizialize the containers. It sets _equation, sets all the textures
func setup(equation: Equation) -> void:
	self._equation = equation
	var size = equation.get_size()

	for i in size:
		if equation.get_coeff()[i] != 1:
			pass

		var fruit = preload(PATH_TO_SCENES + "fruit.tscn").instantiate()
		fruit.set_texture(load(PATH_TO_FRUIT + equation.get_variables()[i].to_lower() + ".png"))
		add_child(fruit)

		if i < size - 1:
			var sign = preload(PATH_TO_SCENES + "sign.tscn").instantiate()
			var sign_name = equation.get_sign()[i]
			if sign_name == ":":
				sign_name = "division"
			sign.set_texture(load(PATH_TO_SIGN + sign_name + ".png"))
			add_child(sign)

	var eq = preload(PATH_TO_SCENES + "sign.tscn").instantiate()
	eq.set_texture(load(PATH_TO_SIGN + "=.png"))
	add_child(eq)

	var res = preload(PATH_TO_SCENES + "rhs.tscn").instantiate()
	res.set_text(str(equation.calculate_result()))
	add_child(res)


## Changes the last equation because it has to be the question.
func setup_last_one() -> void:
	$Rhs.set_text("??")
	self.set_name("FinalEquation")


## Fades itself in.
func _on_tree_entered() -> void:
	self.get_parent().modulate.a = 1.0
	self.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)
	await tween.finished
	self.tween_finished.emit()
