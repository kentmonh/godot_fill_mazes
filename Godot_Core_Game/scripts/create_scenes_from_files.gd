tool
extends EditorScript
class_name CreateScenesFromFiles

# Variables will change in each time create scenes
var file_path = "res://scripts/levels_db/5_6_28.txt"
var camera_zoom = preload("res://play_scenes/cameras_zoom/camera_zoom_0.8.tscn")
# Number of level category
var level_category = 4
# Number of levels in category created
var level_created = 89
# Number of levels to create in this level
var number_of_scenes_created : int = 300

var paths = []
var path = []
var row : int
var column : int
var grid_size = 40
var block = preload("res://scenes/block.tscn")
var middle_screen = Vector2(4, 7)

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
	
	# Create scenes
	var center_level_x = (row - 1) / 2 + (row  - 1) % 2 * 0.5
	var center_level_y = (column - 1) / 2 + (column  - 1) % 2 * 0.5
	var center_screen = middle_screen - Vector2(center_level_x, center_level_y)
	
	paths.shuffle()
	var path_size : int = paths.size()
	if path_size > number_of_scenes_created:
		path_size = number_of_scenes_created
	for i in path_size:
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
