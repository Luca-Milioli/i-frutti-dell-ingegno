extends CommonUI


func _ready() -> void:
	GameLogic.connect_to_gui(self)


func game_over():
	super.fade_out($TopBar/Text)


func _on_tree_entered():
	await super.fade_in($".")

	$TutorialPopup.queue_free()

	_appear_objects()

	Utils.recursive_disable_buttons(self, false)


func _on_tree_entered_with_tutorial() -> void:
	Utils.recursive_disable_buttons(self, true)
	await super.fade_in($".")
	await super.fade_in($TutorialPopup)
	Utils.recursive_disable_buttons($TutorialPopup, false)


func _on_tutorial_popup_game_start() -> void:
	Utils.recursive_disable_buttons(self, true)
	await super.fade_out($TutorialPopup)
	$TutorialPopup.queue_free()

	_appear_objects()

	Utils.recursive_disable_buttons(self, false)


func _appear_objects() -> void:
	$Blackboard.visible = true
	$Blackboard.first_animation()
	$TopBar.text_first_entrance()
	$AnswerButton.visible = true


func _on_answer_button_pressed() -> void:
	Utils.recursive_disable_buttons(self, true)
	$Keyboard.visible = true
	await super.fade_in($Keyboard, 1.0, 0.8)
	Utils.recursive_disable_buttons($Keyboard, false)


func kill():
	await super.fade_out(self, 0.4)


func _close_keyboard():
	await super.fade_out($Keyboard)
	$Keyboard.reset()
	Utils.recursive_disable_buttons(self, false)


func _on_confirm_pressed() -> void:
	var answer = $Keyboard/Display/Label.get_text()
	if answer.is_valid_int():
		$Blackboard/FinalEquation/Rhs.set_text(answer)
		GameLogic.answer_given(int(answer), $Blackboard/FinalEquation.get_equation())
	
	_close_keyboard()


func _on_close_button_pressed() -> void:
	_close_keyboard()


func _on_blackboard_children_appaered() -> void:
	if GameLogic.get_current_round() != 1:  # if it's first round it will appear in _appear_objects()
		$AnswerButton.visible = true


func _on_wrong_answer() -> void:
	await get_tree().create_timer(0.3).timeout
	
	var pos = $Blackboard/FinalEquation/Rhs.position
	var tween = create_tween().set_parallel()
	
	tween.tween_property($Blackboard/FinalEquation/Rhs, "position", pos + Vector2(-10, 0), 0.1)
	tween.tween_property($Blackboard/FinalEquation/Rhs, "position", pos + Vector2(10, 0), 0.1).set_delay(0.1)
	tween.tween_property($Blackboard/FinalEquation/Rhs, "position", pos, 0.1).set_delay(0.2)
	
	tween.finished.connect(func(): $Blackboard/FinalEquation/Rhs.set_text("??"))


func _on_round_finished() -> void:
	await get_tree().create_timer(0.5).timeout
	
	$AnswerButton.fade_out()

	await $Blackboard.kill()
