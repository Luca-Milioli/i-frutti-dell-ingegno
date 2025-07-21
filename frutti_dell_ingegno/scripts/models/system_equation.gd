class_name SystemEquation

var _equations : Array[Equation]
var _n_equation : int
var _final_result : int

func _init(equations : Array[Equation]) -> void:
	self._equations = equations
	self._n_equation = equations.size()
	self._final_result = self._equations[_n_equation - 1].calculate_result()

func get_equations():
	return self._equations
	
func get_final_result():
	return self._final_result

func get_n_equation():
	return self._n_equation

func _to_string() -> String:
	var text = ""
	var i = 1
	for eq in _equations:
		text += "Equation: "+str(i)+": \n"
		text += eq._to_string()
		text += "\n\n"
		i += 1
	
	return text
