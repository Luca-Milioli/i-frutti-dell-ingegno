extends Node	# needed for autoload (singleton)

signal wrong_answer

const MAX_ROUND = 5

var _correct_answer: int = 0
var _score: int = 0
var _max_score: int = 0

func get_max_round() -> int:
	return MAX_ROUND
	
func _check_answers(answers: Array[int]) -> bool:
	return true

func get_score() -> int:
	return self._score

func increase_max_score(score: int) -> void:
	self._max_score += score

func get_max_score() -> int:
	return self._max_score

func get_correct_answer() -> int:
	return self._correct_answer

func win() -> bool:
	return self._score >= self._max_score

func reset() -> void:
	self._score = 0
	self._max_score = 0
	self._correct_answer = 0
