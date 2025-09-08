## Main. It manages transition from a scene to another (menu, gui).
extends Node
class_name Main

## Window of browser. Different from get_window()
var window
## True if this game is running on mobile.
var mobile: bool

## Connects some signal of get_window and calculate the top window.
func _ready() -> void:
	self.mobile = (
		OS.has_feature("mobile") or OS.has_feature("web_ios") or OS.has_feature("web_android")
	)
	if OS.get_name() == "Web":
		self.window = JavaScriptBridge.get_interface("window").parent
		get_window().focus_entered.connect(_on_window_focus_entered)
		get_window().focus_exited.connect(_on_window_focus_exited)


## When window is not in background anymore, it resumes the audio.
func _on_window_focus_entered() -> void:
	AudioManager.set_paused(false)


## When window goes in background, it pauses the audio.
func _on_window_focus_exited() -> void:
	AudioManager.set_paused(true)


## Resize viewport as viewportcontainer.
## Checks every frame the screen orientation and stops the game (mobile only).
func _process(_delta):
	$SubViewportContainer/SubViewport.size = $SubViewportContainer.size

	if self.mobile:
		if window.matchMedia("(orientation: portrait)").matches:
			$SubViewportContainer/SubViewport/RotateWarning.visible = true
			set_paused(true)
		else:
			$SubViewportContainer/SubViewport/RotateWarning.visible = false
			set_paused(false)


## Put the game and the audio in pause.
func set_paused(paused: bool) -> void:
	if paused != get_tree().paused:
		get_tree().paused = paused
		AudioManager.set_paused(paused)


## URL is the "parent" of the actual URL.
## When "back" button is pressed on menu, calls the URL using javascript eval function.
## if the game is a webexport. Quits the application otherwise.
func _on_end_menu_back_pressed():
	if OS.get_name() == "Web":
		var URL = JavaScriptBridge.call(
			"eval", "top.location.href.split('/').slice(0, -2).join('/');"
		)
		JavaScriptBridge.call("eval", "top.location.href = '" + URL + "';")
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
		$SubViewportContainer/SubViewport.move_child.call_deferred(
			$SubViewportContainer/SubViewport/FullScreenButton, -1
		)
