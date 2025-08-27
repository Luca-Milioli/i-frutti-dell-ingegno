## Model class that represent an equation system.
class_name SystemEquation

## Array of the equations in the system.
var _equations: Array[Equation]
## Number of equations in the system
var _n_equation: int


## Constructor method.
func _init(equations: Array[Equation], _score: int = 1) -> void:
	self._equations = equations
	self._n_equation = equations.size()


## Getter for _equations.
func get_equations() -> Array[Equation]:
	return self._equations


## Returns the result of the last equation (the question).
func get_final_result() -> int:
	return self._equations[_n_equation - 1].calculate_result()


## Getter for number of equations.
func get_n_equation() -> int:
	return self._n_equation


## Method str().
func _to_string() -> String:
	var text = ""
	var i = 1
	for eq in _equations:
		text += "Equation: " + str(i) + ": \n"
		text += eq._to_string()
		text += "\n\n"
		i += 1

	return text
