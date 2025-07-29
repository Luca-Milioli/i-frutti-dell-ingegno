extends Node
class_name DataManager

const DATA_PATH = "res://data/data_equation.csv.txt"
var data: Array


static func get_max_rounds():
	var file = FileAccess.open(DATA_PATH, FileAccess.READ)
	var rounds = file.get_line().to_int()
	file.close()

	return rounds


func read_csv(separator = ",") -> Array:
	var file := FileAccess.open(self.DATA_PATH, FileAccess.READ)

	if not file:
		push_error("Error, data file not found.")
		return []

	# first line is MAX ROUNDS
	file.get_line()

	while not file.eof_reached():
		var system = []
		while not file.eof_reached():
			var pos = file.get_position()
			var line = file.get_line().strip_edges()
			if line == separator or line.is_empty():  # end of system
				break
			file.seek(pos)  # if not end of system, bring back cursor

			var row_data: Dictionary = {
				"coeff": [],
				"var": [],
				"value": [],
				"sign": [],
			}

			var attributes = file.get_csv_line(separator)
			for i in range(attributes.size()):
				var value = attributes[i]
				var key: StringName
				match i % 4:
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
			system.append(row_data)
		data.append(system)

	file.close()
	return data
