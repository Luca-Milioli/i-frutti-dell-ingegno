extends CommonUI


func game_over():
	super.fade_out($TopBar/Text)


func _on_tree_entered() -> void:
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
	if $AnswerButton/Text.get_text() == "Inserisci risposta" and not $AnswerButton.disabled:
		Utils.recursive_disable_buttons(self, true)
		$Keyboard.visible = true
		await super.fade_in($Keyboard, 1.0, 0.8)
		Utils.recursive_disable_buttons($Keyboard, false)
	else:
		GameLogic.answer_given(
			int($Blackboard/FinalEquation/Rhs.get_text()), $Blackboard/FinalEquation.get_equation()
		)
		$AnswerButton.fade_out()
		
		await $Blackboard.kill()


func kill():
	await super.fade_out(self, 0.4)


func _close_keyboard():
	await super.fade_out($Keyboard)
	$Keyboard.reset()
	Utils.recursive_disable_buttons(self, false)


func _on_confirm_pressed() -> void:
	if $Keyboard/Display/Label.get_text().is_valid_int():
		$AnswerButton/Text.set_text("Invia risposta")
	_close_keyboard()


func _on_close_button_pressed() -> void:
	_close_keyboard()


func _on_blackboard_children_appaered() -> void:
	if GameLogic.get_current_round() != 1:	# if it's first round it will appear in _appear_objects()
		$AnswerButton/Text.set_text("Inserisci risposta")
		$AnswerButton.visible = true
