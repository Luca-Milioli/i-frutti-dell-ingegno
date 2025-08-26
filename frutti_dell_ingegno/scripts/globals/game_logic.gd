extends Node  # needed for autoload (singleton)

var MAX_ROUND
var _current_round: int = 1

signal round_finished
signal wrong_answer


func _ready() -> void:
	MAX_ROUND = DataManager.get_max_rounds()


func get_max_round() -> int:
	return MAX_ROUND


func get_current_round() -> int:
	return self._current_round


func connect_to_gui(gui: Node) -> void:
	self.round_finished.connect(gui._on_round_finished)
	self.wrong_answer.connect(gui._on_wrong_answer)


func answer_given(answer: int, equation: Equation) -> void:
	if answer == equation.calculate_result():
		self.round_finished.emit()
		self._current_round += 1
		AudioManager.correct()
	else:
		self.wrong_answer.emit()
		AudioManager.wrong()


func reset() -> void:
	self._current_round = 1
