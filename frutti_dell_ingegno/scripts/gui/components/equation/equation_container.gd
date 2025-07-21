extends HBoxContainer

const PATH_TO_FRUIT = "res://art/graphics/fruit/"
const PATH_TO_SIGN = "res://art/graphics/signs/"
const PATH_TO_SCENES = "res://scenes/components/equation/"

func setup(equation: Equation) -> void:
	var size = equation.get_size()
	
	for i in size:
		if equation.get_coeff()[i] != 1:
			pass
		
		var fruit = preload(PATH_TO_SCENES + "fruit.tscn").instantiate()
		fruit.set_texture(load(PATH_TO_FRUIT + equation.get_variables()[i].to_lower() + ".png"))
		add_child(fruit)
		
		if i < size - 1:
			var sign = preload(PATH_TO_SCENES + "sign.tscn").instantiate()
			sign.set_texture(load(PATH_TO_SIGN + equation.get_sign()[i] + ".png"))
			add_child(sign)
	
	var eq = preload(PATH_TO_SCENES + "sign.tscn").instantiate()
	eq.set_texture(load(PATH_TO_SIGN + "=.png"))
	add_child(eq)
	
	var res = preload(PATH_TO_SCENES + "rhs.tscn").instantiate()
	res.set_text(str(equation.calculate_result()))
	add_child(res)

func setup_last_one() -> void:
	$Rhs.set_text("??")


func _on_tree_entered() -> void:
	self.get_parent().modulate.a = 1.0
	self.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)
	await tween.finished
