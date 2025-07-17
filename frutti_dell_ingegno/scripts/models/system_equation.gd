class_name SystemEquation

var _equations : Array[Equation]
var _block_size : int
var _final_result : int

func _init(equations : Array[Equation], block_size = 4) -> void:
	self._equations = equations
	self._block_size = block_size
	self._final_result = self._equations[block_size - 1].calculate_result()

func get_equations():
	return self._equations
	
func get_final_result():
	return self._final_result

func get_block_size():
	return self._block_size

func _to_string() -> String:
	var text = ""
	var i = 1
	for eq in _equations:
		text += "Equation: "+str(i)+": \n"
		text += eq._to_string()
		text += "\n\n"
		i += 1
	
	return text
