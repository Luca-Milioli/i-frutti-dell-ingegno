## Singleton Factory that creates SystemEquation object. It extends DataManager, so it can read data from csv.
extends DataManager

## Stores data. It removes elements already created. When it's empty it copies data from
## the attribute data, which is immutable.
var _system_data: Array


## Reads data from csv, if necessary.
func start() -> void:
	if self._system_data.is_empty():
		self._system_data = read_csv()


## Creates and returns a SystemEquation from data.
func make_system_equation() -> SystemEquation:
	start()
	var equations: Array[Equation]
	var system = self._system_data.pop_back()
	var size = system.size()

	for i in size:
		equations.append(
			Equation.new(
				system[i]["coeff"], system[i]["var"], system[i]["value"], system[i]["sign"]
			)
		)

	return SystemEquation.new(equations)
