extends DataManager

# all equations of file
var equations : Array

func _to_string() -> String:
	return str(equations)
	
func start():
	if self.equations.size() == 0:
		self.equations = super.read_csv('|')

func get_equations():
	return self.equations
	
func make_equation(equation_number):
	var data : Dictionary = equations[equation_number]
	return Equation.new(data["coeff"], data["var"], data["value"], data["sign"])
