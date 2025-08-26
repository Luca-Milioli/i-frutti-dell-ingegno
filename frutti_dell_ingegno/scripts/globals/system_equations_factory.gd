extends DataManager


func start() -> void:
	read_csv()


func make_system_equation() -> SystemEquation:
	start()
	var equations: Array[Equation]
	var system = self.data.pop_back()
	var size = system.size()

	for i in size:
		equations.append(
			Equation.new(
				system[i]["coeff"], system[i]["var"], system[i]["value"], system[i]["sign"]
			)
		)

	return SystemEquation.new(equations)
