extends HBoxContainer

const PATH_TO_FRUIT = "res://art/graphics/fruit/"
const PATH_TO_SIGN = "res://art/graphics/signs/"

func setup(equation: Equation):
	var size = equation.get_size()
	
	for i in size:
		var fruit = preload("res://scenes/components/equation/fruit.tscn").instantiate()
		fruit.set_texture(load(PATH_TO_FRUIT + equation.get_variables()[i].to_lower() + ".png"))
		
		var sign = preload("res://scenes/components/equation/sign.tscn").instantiate()
		sign.set_texture(load(PATH_TO_SIGN + equation.get_variables()[i] + ".png"))
		
		add_child(fruit)
		add_child(sign)
	
	var eq = preload("res://scenes/components/equation/sign.tscn").instantiate()
	eq.set_texture(load(PATH_TO_SIGN + "=.png"))
