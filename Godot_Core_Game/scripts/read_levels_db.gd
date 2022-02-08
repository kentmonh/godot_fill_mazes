tool
extends EditorScript
class_name ReadFile

var file_path = "res://scripts/levels_db/3_3_7.txt"
var paths = []
var path = []
var row : int
var column : int

func _run():
	
	var file = File.new()
	file.open(file_path, File.READ)
	var file_name = file.get_path().trim_prefix("res://scripts/levels_db/")

	row = int(file_name.left(1))
	column = int(file_name.left(3).right(2))
	
	while not file.eof_reached(): # iterate through all lines until the end of file is reached
		var line = file.get_line()
		line = line.trim_prefix("<").trim_suffix(">")
		var array = line.split("><", false)
		for item in array:
			var numbers = item.split(", ", false)
			path.append(Vector2( int(numbers[0]), int(numbers[1]) ))
		if path.size() > 0:
			paths.append(path)
			path = []
	
	file.close()
