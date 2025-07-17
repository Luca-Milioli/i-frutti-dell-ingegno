extends Node
class_name DataManager

const DATA_PATH = "res://data/data_equation.csv"
var data : Array[Dictionary]

func read_csv(separator = ",") -> Array:
	var file := FileAccess.open(self.DATA_PATH, FileAccess.READ)

	if not file:
		push_error("Errore nell'aprire il file.")
		return []

	while not file.eof_reached():
		var row_data : Dictionary = {
			"coeff" : [],
			"var" : [],
			"value" : [],
			"sign" : [],
		}
	
		var attributes = file.get_line().strip_edges().split(separator)
		for i in range(attributes.size()):
			var value = attributes[i]
			var key : StringName
			match (i % 4):
				0:
					key = "coeff"
					value = int(value)
				1:
					key = "var"
				2:
					key = "value"
					value = int(value)
				3:
					key = "sign"
			row_data[key].append(value)
	
		data.append(row_data)
	
	file.close()
	return data
