extends Object

class_name Utils

static func recursive_disable_buttons(obj : Node, disabled):
	var children = obj.get_children()
	if obj is BaseButton:
		debug_print(obj)
		obj.disabled = disabled
	if children.size() > 0:
		for child in children:
			recursive_disable_buttons(child, disabled)

static func debug_print(obj : Node):
	print("Call from: "+str(obj.get_name()))
