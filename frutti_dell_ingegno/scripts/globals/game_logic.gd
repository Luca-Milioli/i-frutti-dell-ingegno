extends Node	# needed for autoload (singleton)

const MAX_ROUND = 5

var _correct_answers: int = 0
var _score: int = 0
var _max_score: int = 0

func get_score() -> int:
	return self._score

func increase_max_score(score: int) -> void:
	self._max_score += score

func get_max_score() -> int:
	return self._max_score

func get_correct_answers() -> int:
	return self._correct_answers

func answer_given(answer: int, system: SystemEquation) -> void:
	if answer == system.get_equations()[-1].calculate_result():
		_score += system.get_equations()[-1].get_score()
		_correct_answers += 1

func win() -> bool:
	return self._score >= self._max_score

func reset() -> void:
	self._score = 0
	self._max_score = 0
	self._correct_answers = 0
