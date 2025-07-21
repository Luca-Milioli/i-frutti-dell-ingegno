extends EquationFactory

var _equation_system_created = 0

func _ready() -> void:
	self._equation_system_created = 0
	
func make_system_equation():
	super.start()
	var array : Array[Equation]
	
	var block_size = calculate_block_size()
	
	# NON METTERE QUELLI GIA USCITI
	var random_block = randi() % (super.get_equations().size() / block_size)
	
	var block_offset = block_size * random_block
	for i in range(block_size):
		array.append(make_equation(i + block_offset))
	
	_equation_system_created += 1
	return SystemEquation.new(array, block_size)
	

func calculate_block_size():
	return 4
