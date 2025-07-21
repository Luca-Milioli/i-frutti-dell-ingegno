extends CommonUI
	
func game_over():
	super.fade_out($TopBar/Text)
	
func _on_tree_entered() -> void:
	await super.fade_in($".")
	Utils.recursive_disable_buttons(self, true)
	await super.fade_in($TutorialPopup)
	Utils.recursive_disable_buttons($TutorialPopup, false)

func _on_tutorial_popup_game_start() -> void:
	await super.fade_out($TutorialPopup)
	$TutorialPopup.queue_free()
	Utils.recursive_disable_buttons(self,false)
	$TopBar/RetryButton.disabled = false
	$Blackboard.visible = true
	#$Round1/Question._on_tree_entered()
	$TopBar.text_first_entrance()
	
