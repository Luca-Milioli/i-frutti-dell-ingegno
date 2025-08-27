## Class that access and store data from csv.
extends Node

class_name DataManager

## Path of .csv where data are stored.
const DATA_PATH = "res://data/data_equation.csv.txt"

## Stores data and after it reads csv the first time, it becomes read_only.
var data: Array


## Returns max number of rounds in the same match.
static func get_max_rounds():
	var file = FileAccess.open(DATA_PATH, FileAccess.READ)
	var rounds = file.get_line().to_int()
	file.close()

	return rounds


## First time it's called it reads csv file in path and stores data, so that it can avoid reding
## csv again. It returns a copy of the data, so that it can be changed.
func read_csv(path: String = DATA_PATH, separator = ",") -> Array:
	if not self.data.is_empty():
		return self.data.duplicate()

	var file := FileAccess.open(path, FileAccess.READ)

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
		self.data.append(system)

	file.close()

	self.data.make_read_only()

	return self.data.duplicate()
