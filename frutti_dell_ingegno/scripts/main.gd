extends Node

func _on_end_menu_back_pressed():
	get_tree().quit()
	
func _on_menu_play_pressed() -> void:
	var menu = get_node("Menu")
	await menu.kill()
	remove_child(menu)
	menu.queue_free()
	
	await _create_rounds()
	
	var win = GameLogic.win()
	
	$Gui.queue_free()
	var next_scene : Node
	if(win):
		next_scene = preload("res://scenes/main_gui/menu/end_menu.tscn").instantiate()
	else:
		next_scene = preload("res://scenes/main_gui/menu/end_menu2.tscn").instantiate()
	
	next_scene.back_pressed.connect(_on_end_menu_back_pressed)
	next_scene.play_pressed.connect(_on_reset)
	add_child(next_scene)

func _on_reset():
	GameLogic.reset()
	SystemEquationsFactory.reset()
	get_tree().reload_current_scene()

func _create_rounds():
	var gui = preload("res://scenes/main_gui/gui.tscn").instantiate()
	gui.get_node("ResetPopup/SplitContainer/Go").pressed.connect(_on_reset)
	add_child(gui)
	for i in range(GameLogic.MAX_ROUND):
		var system_equation = SystemEquationsFactory.make_system_equation()
		print(system_equation.to_string())
		
		var blackboard = $Gui/Blackboard
		blackboard.setup(system_equation)
		
		#gui.move_child(round, -3)
		await blackboard.killed
	gui.game_over()
