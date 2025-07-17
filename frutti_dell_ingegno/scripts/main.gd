extends Node

func _on_end_menu_back_pressed():
	get_tree().quit()
	
func _on_menu_play_pressed() -> void:
	var menu = get_node("Menu")
	await menu.kill()
	remove_child(menu)
	menu.queue_free()
	EquationFactory.start()
	#await _create_round()
	_create_rounds()
	
	#var score = GameLogic.get_score()
	#var win = GameLogic.win()
	
	
	var next_scene : Node
	#if(1):
	#	next_scene = preload("res://scenes/main_gui/menu/end_menu.tscn").instantiate()
	#else:
	#	next_scene = preload("res://scenes/main_gui/menu/end_menu2.tscn").instantiate()
	
	#next_scene.back_pressed.connect(_on_end_menu_back_pressed)
	#next_scene.play_pressed.connect(_on_end_menu_play_pressed)
	#add_child(next_scene)

func reset():
	#GameLogic.reset()
	#RoundFactory.reset()
	get_tree().reload_current_scene()
	
func _on_end_menu_play_pressed() -> void:
	reset()

func _on_reset_confirmed() -> void:
	reset()

func _create_rounds():
	var system_equation : SystemEquation
	system_equation = SystemEquationsFactory.make_system_equation()
	print(system_equation.to_string())
		
		
	#var gui = preload("res://scenes/main_gui/gui.tscn").instantiate()
	#gui.get_node("ResetPopup/SplitContainer/Go").pressed.connect(_on_reset_confirmed)
	#add_child(gui)
	#for i in range(ROUNDS):
		#var round = RoundFactory.create_round(i)
		#gui.add_child(round)
		#gui.move_child(round, -3)
		#await round.kill_me
		#gui.remove_child(round)
		#round.queue_free()
	#gui.game_over()


func _on_menu_back_pressed() -> void:
	pass # Replace with function body.
