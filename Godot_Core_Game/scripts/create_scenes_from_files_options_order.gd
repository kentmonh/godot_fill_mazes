tool
extends EditorScript
class_name CreateScenesFromFilesOptionsOrder

# Variables will change in each time create scenes
var file_path = "res://scripts/levels_db/6_6_33.txt"
var camera_zoom = preload("res://play_scenes/cameras_zoom/camera_zoom_0.82.tscn")
# Number of level category
var level_category = 7
# Number of levels in category created
var level_created = 232
# Number of levels to create in this level
var number_of_scenes_created : int = 370

var paths = []
var path = []
var row : int
var column : int
var grid_size = 40
var block = preload("res://scenes/block.tscn")
var middle_screen = Vector2(4, 7)
var path_option_dic = []

func _run():
	# Read file and get data, then save to paths
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
	
	# Sort in options order
	paths.shuffle()
	for path in paths:
		path_option_dic.append([path, caluculate_options_path(path)])

	paths.clear()
	path_option_dic.sort_custom(PathOptionSorter, "sort_descending")
	for path in path_option_dic:
		paths.append(path[0])
	# Now the paths are in order from hard to easy (more options to less)
	
	# Create scenes
	var center_level_x = (row - 1) / 2 + (row  - 1) % 2 * 0.5
	var center_level_y = (column - 1) / 2 + (column  - 1) % 2 * 0.5
	var center_screen = middle_screen - Vector2(center_level_x, center_level_y)

	var path_size : int = paths.size()
	if path_size > number_of_scenes_created:
		path_size = number_of_scenes_created
	for i in range(path_size - 1, -1, -1):
		var scene = Node2D.new()
		scene.name = "Game_Template"
		var script = load("res://play_scenes/game_template.gd")
		scene.set_script(script)

		var camera = camera_zoom.instance()
		scene.add_child(camera)
		camera.owner = scene

		for j in paths[i].size():
			var new_block = block.instance()
			new_block.position = (paths[i][j] + center_screen) * grid_size
			new_block.visible = true
			scene.add_child(new_block)
			new_block.owner = scene

		scene.visible = true
		var toSave : PackedScene = PackedScene.new()
		toSave.pack(scene)

		if i + level_created < 300:
			ResourceSaver.save("res://play_scenes/level_" + String(level_category) + "/level_" + String(i + 1 + level_created) + ".tscn", toSave)
		else:
			ResourceSaver.save("res://play_scenes/level_" + String(level_category + 1) + "/level_" + String(i + 1 + level_created - 300) + ".tscn", toSave)
	print("Done")

# Calculate the number of options in path
func caluculate_options_path(path : Array) -> int:
	var options : int = 0
	for position in path:
		options += caluculate_options_position(position, path)
	return options

# Calculate the number of options around a point
func caluculate_options_position(position : Vector2, path : Array) -> int:
	var options : int = 0
	for pos in next_to_positions(position):
		if pos.x >= 0 && pos.x < row && pos.y >= 0 && pos.y < column && path.has(pos):
			options += 1
	return options

# Get neighbor positions
func next_to_positions(position : Vector2) -> Array:
	var next_to_positions = [position + Vector2.RIGHT, position + Vector2.DOWN, \
	position + Vector2.LEFT, position + Vector2.UP]
	return next_to_positions

class PathOptionSorter:
	static func sort_descending(a, b):
		if a[1] > b[1]:
			return true
		return false
