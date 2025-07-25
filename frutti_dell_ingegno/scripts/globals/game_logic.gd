extends Node	# needed for autoload (singleton)

var MAX_ROUND

var _correct_answers: int = 0

func _ready() -> void:
	MAX_ROUND = DataManager.get_max_rounds()
	
func get_max_round() -> int:
	return MAX_ROUND
	
func get_correct_answers() -> int:
	return self._correct_answers

func answer_given(answer: int, equation: Equation) -> void:
	if answer == equation.calculate_result():
		AudioManager.correct()
		_correct_answers += 1
	else:
		AudioManager.wrong()

func win() -> bool:
	return self._correct_answers >= MAX_ROUND

func reset() -> void:
	self._correct_answers = 0
