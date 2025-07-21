extends DataManager

var _systems: Array
var _n_systems: int

func start() -> Array:
	if self._systems.is_empty():
		self._systems = super.read_csv()
		_n_systems = self._systems.size()
	return self._systems

func pop_system(index: int) -> Array:
	if self._systems.is_empty():
		self._systems = super.read_csv()
		_n_systems = self._systems.size()
	_n_systems -= 1
	return self._systems.pop_at(index)

func make_system_equation() -> SystemEquation:
	if _n_systems == 0:
		start()
	var system_num = randi() % _n_systems
	var equations : Array[Equation]
	var system = pop_system(system_num)
	var size = system.size()
	
	for i in size:
		equations.append(Equation.new(system[i]["coeff"], system[i]["var"], system[i]["value"], system[i]["sign"]))
	
	return SystemEquation.new(equations)
