## View of the game. It contains a Blackboard, a Keyboard... and manages theirs
## entrances and exits.
extends CommonUI

class_name Gui


## Connects GameLogic signals to its method.
func _ready() -> void:
	GameLogic.connect_to_gui(self)


## Called when game is finished.
func game_over():
	super.fade_out($TopBar/Text)


## Called when it enters the tree. It fades itself in and makes appear objects, starting the game.
func _on_tree_entered():
	await super.fade_in($".")

	$TutorialPopup.queue_free()

	_appear_objects()

	Utils.recursive_disable_buttons(self, false)


## Called when it enters the tree with tutorial.
func _on_tree_entered_with_tutorial() -> void:
	Utils.recursive_disable_buttons(self, true)
	await super.fade_in($".")
	await super.fade_in($TutorialPopup)
	Utils.recursive_disable_buttons($TutorialPopup, false)


## Let game start after tutorial. Makes appear objects.
func _on_tutorial_popup_game_start() -> void:
	Utils.recursive_disable_buttons(self, true)
	await super.fade_out($TutorialPopup)
	$TutorialPopup.queue_free()

	_appear_objects()

	Utils.recursive_disable_buttons(self, false)


## Makes appear blackboard, text and button, so the game can start.
func _appear_objects() -> void:
	$Blackboard.visible = true
	$Blackboard.first_animation()
	$TopBar.text_first_entrance()


## Called when AnswerButton is clicked. Makes keyboard appear.
func _on_answer_button_pressed() -> void:
	Utils.recursive_disable_buttons(self, true)
	$Keyboard.visible = true
	await super.fade_in($Keyboard, 1.0, 0.8)
	Utils.recursive_disable_buttons($Keyboard, false)


## Fades itself out.
func kill():
	await super.fade_out(self, 0.4)


## Close Keyboard.
func _close_keyboard():
	await super.fade_out($Keyboard)
	$Keyboard.reset()
	Utils.recursive_disable_buttons(self, false)


## Called when ConfirmButton (in Keyboard) is clicked. Send the answer to
## GameLogic and close Keyboard.
func _on_confirm_pressed() -> void:
	var answer = $Keyboard/Display/Label.get_text()
	await _close_keyboard()

	Utils.recursive_disable_buttons($AnswerButton, true)

	if answer.is_valid_int():
		$Blackboard/FinalEquation/Rhs.set_text(answer)
		GameLogic.answer_given(int(answer), $Blackboard/FinalEquation.get_equation())


## Called when CloseButton (in Keyboard) is clicked. Close Keyboard.
func _on_close_button_pressed() -> void:
	_close_keyboard()


## Called when EquationContainer appeared. AnswerButton becomes visible.
func _on_blackboard_children_appaered() -> void:
	$AnswerButton.visible = true


## Called when the answer given is wrong. It clears the answer, animating, and write "??" again.
func _on_wrong_answer() -> void:
	await get_tree().create_timer(0.3).timeout

	var pos = $Blackboard/FinalEquation/Rhs.position
	var tween = create_tween().set_parallel()

	tween.tween_property($Blackboard/FinalEquation/Rhs, "position", pos + Vector2(-10, 0), 0.1)
	(
		tween
		. tween_property($Blackboard/FinalEquation/Rhs, "position", pos + Vector2(10, 0), 0.1)
		. set_delay(0.1)
	)
	tween.tween_property($Blackboard/FinalEquation/Rhs, "position", pos, 0.1).set_delay(0.2)

	await tween.finished

	$Blackboard/FinalEquation/Rhs.set_text("??")
	Utils.recursive_disable_buttons($AnswerButton, false)


## Called when the answer given is correct. Makes disappear AnswerButton and frees Blackboard.
func _on_round_finished() -> void:
	await get_tree().create_timer(0.5).timeout

	$AnswerButton.fade_out()

	await $Blackboard.kill()
