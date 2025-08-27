## Class model that represent an Equation.
extends Object
class_name Equation

## Array of coefficients.
var _coeffs: Array
## Array of fruit names.
var _variables: Array
## Array of values of variables.
var _values: Array
## Array of signs between values.
var _sign: Array


## Constructor method.
func _init(coeff: Array, variables: Array, values: Array, sign: Array):
	self._coeffs = coeff
	self._variables = variables
	self._values = values
	self._sign = sign


## Getter for coeffs.
func get_coeff():
	return self._coeffs


## Getter for variables.
func get_variables():
	return self._variables


## Getter for values.
func get_values():
	return self._values


## Getter for signs.
func get_sign():
	return self._sign


## Returns number of variables in the equation.
func get_size():
	return self._variables.size()


## Returns the result of the left hand side expression.
func calculate_result() -> int:
	var res = get_coeff()[0] * get_values()[0]

	# signs are 1 less than variables, so let's calculate the first value and
	# iterate from second to last one. [a, b, c] [+, -] --> a + [b, c] [+, -]
	for i in range(1, get_variables().size()):
		var variable_value = get_coeff()[i] * get_values()[i]

		match get_sign()[i - 1]:
			"+":
				res += variable_value
			"-":
				res -= variable_value
			"*", "x":
				res *= variable_value
			"/", ":":
				res /= variable_value

	return res


## Method str().
func _to_string() -> String:
	var text: String = ""
	var text2: String = ""

	for i in range(0, get_sign().size()):
		text += str(get_coeff()[i])
		text += str(get_variables()[i])
		text2 += str(get_values()[i])
		text += " "
		text += str(get_sign()[i])
		text += " "
		text2 += " "
		text2 += str(get_sign()[i])
		text2 += " "
	text += str(get_coeff()[-1])
	text += str(get_variables()[-1])
	text2 += str(get_values()[-1])
	text += " = "
	text2 += " = "

	var res = str(calculate_result())
	text += res
	text2 += res

	return text + "\n" + text2
