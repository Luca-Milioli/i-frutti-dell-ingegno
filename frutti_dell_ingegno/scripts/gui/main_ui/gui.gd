extends CommonUI


func game_over():
	super.fade_out($TopBar/Text)


func _on_tree_entered():
	await super.fade_in($".")

	var tween = create_tween()
	$AnswerButton.set_visible(true)
	$AnswerButton.modulate.a = 0.0
	tween.tween_property($AnswerButton, "modulate:a", 1.0, 1.0)

	$TutorialPopup.queue_free()
	$Blackboard.visible = true
	$Blackboard.first_animation()
	$TopBar.text_first_entrance()
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
	$Blackboard.visible = true
	$Blackboard.first_animation()
	$TopBar.text_first_entrance()
	Utils.recursive_disable_buttons(self, false)


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
		Utils.recursive_disable_buttons($AnswerButton, true)
		if GameLogic.get_current_round() - 1 != GameLogic.MAX_ROUND:
			$AnswerButton/Text.set_text("Inserisci risposta")
			Utils.recursive_disable_buttons($AnswerButton, false)
			await $Blackboard.kill()
		else:
			Utils.recursive_disable_buttons($AnswerButton, true)
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
