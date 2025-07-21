extends DataManager

var _systems: Array
var _n_systems: int

func reset() -> void:
	self._systems = []
	self._n_systems = 0

func start() -> void:
	if self._systems.is_empty():
		self._systems = super.read_csv()
		_n_systems = self._systems.size()

func pop_system(index: int) -> Array:
	if self._systems.is_empty():
		self._systems = super.read_csv()
		_n_systems = self._systems.size()
	_n_systems -= 1
	return self._systems.pop_at(index)

func make_system_equation() -> SystemEquation:
	start()
	var system_num = randi() % _n_systems
	var equations : Array[Equation]
	var system = pop_system(system_num)
	var size = system.size()
	
	for i in size:
		equations.append(Equation.new(system[i]["coeff"], system[i]["var"], system[i]["value"], system[i]["sign"]))
	
	GameLogic.increase_max_score(1)
	return SystemEquation.new(equations, 1)
