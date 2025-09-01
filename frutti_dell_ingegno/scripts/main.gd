## Main. It manages transition from a scene to another (menu, gui).
extends Node
class_name Main

## URL of site that it'll be redirected to.
const URL = "https://spreafico.net/"


## Makes the background transparent
func _ready() -> void:
	get_tree().root.transparent_bg = true


## Redirects to the URL.
func _on_end_menu_back_pressed():
	if OS.get_name() == "Web":
		var js = Engine.get_singleton("JavaScriptBridge")
		js.call("eval", "window.location.href = '" + URL + "';")
	else:
		get_tree().quit()


## Called when it enters the tree. It makes the game start and wait until the end.
func _run():
	$SubViewportContainer/SubViewport/Menu.queue_free()
	await get_tree().process_frame

	await _create_rounds()

	var win_menu = preload("res://scenes/main_gui/menu/end_menu.tscn").instantiate()

	win_menu.back_pressed.connect(_on_end_menu_back_pressed)
	win_menu.play_pressed.connect(_on_reset)

	await $SubViewportContainer/SubViewport/Gui.kill()
	$SubViewportContainer/SubViewport/Gui.queue_free()

	$SubViewportContainer/SubViewport.add_child(win_menu)


## Called when StartMenu button is pressed. Calls _run
func _on_menu_play_pressed() -> void:
	var menu = $SubViewportContainer/SubViewport.get_node("Menu")
	await menu.kill()
	$SubViewportContainer/SubViewport.remove_child(menu)
	menu.queue_free()
	_run()


## Replay another match.
func _on_reset():
	AudioManager.reset()
	GameLogic.reset()
	get_tree().reload_current_scene()


## Body of the game. Creates Gui and setups the blackboard every round. Wait until
## game over.
func _create_rounds():
	var gui = preload("res://scenes/main_gui/gui.tscn").instantiate()

	gui.get_node("ResetPopup/SplitContainer/Go").pressed.connect(_on_reset)
	$SubViewportContainer/SubViewport.add_child(gui)
	for i in range(GameLogic.MAX_ROUND):
		var system_equation = SystemEquationsFactory.make_system_equation()

		$SubViewportContainer/SubViewport/Gui/Blackboard.setup(system_equation)

		await $SubViewportContainer/SubViewport/Gui/Blackboard.killed
	gui.game_over()


## Called when a child is added. It moves FullScreenButton in last position.
func _on_child_entered_tree(node: Node) -> void:
	if $SubViewportContainer/SubViewport.has_node("FullScreenButton"):
		$SubViewportContainer/SubViewport.move_child.call_deferred($SubViewportContainer/SubViewport/FullScreenButton, -1)
