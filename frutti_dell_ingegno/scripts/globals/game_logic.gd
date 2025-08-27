## Logic of the game such as checking if an answer is correct.
## Singleton.
extends Node  # needed for autoload (singleton)

## Max number of round in the same match.
var MAX_ROUND: int
## Current round.
var _current_round: int = 1

## Emitted when an answer is correctly answered, so the round is finished.
signal round_finished
## Emitted when an answer is wrongly answered.
signal wrong_answer


## Set MAX_ROUND.
func _ready() -> void:
	MAX_ROUND = DataManager.get_max_rounds()


## Getter for MAX_ROUND.
func get_max_round() -> int:
	return MAX_ROUND


## Getter for current_round.
func get_current_round() -> int:
	return self._current_round


## Connects signals to Gui.
func connect_to_gui(gui: Node) -> void:
	self.round_finished.connect(gui._on_round_finished)
	self.wrong_answer.connect(gui._on_wrong_answer)


## Called when an answer is given. Behave differently if it's wrong or right. Emits
## a signal and plays a sound.
func answer_given(answer: int, equation: Equation) -> void:
	if answer == equation.calculate_result():
		self.round_finished.emit()
		self._current_round += 1
		AudioManager.correct()
	else:
		self.wrong_answer.emit()
		AudioManager.wrong()


## Reset attributes.
func reset() -> void:
	self._current_round = 1
