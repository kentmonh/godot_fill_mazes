tool
extends EditorScript

var grid_size = 40
var block = load("res://scenes/block.tscn")
var camera_zoom = load("res://play_scenes/cameras_zoom/camera_zoom_0.65.tscn")

var middle_screen = Vector2(4, 7)
# Number of level category
var level_category = 1
# Number of levels created
var level_created = 1
# Number of levels to create in this level
var size : int = 1

func _run():
	var create_levels = CreateLevels.new()
	create_levels._run()

	var center_level_x = (create_levels.level.row_length - 1) / 2 + (create_levels.level.row_length - 1) % 2 * 0.5
	var center_level_y = (create_levels.level.column_length - 1) / 2 + (create_levels.level.column_length - 1) % 2 * 0.5

	var center_screen = middle_screen - Vector2(center_level_x, center_level_y)
	
	create_levels.all_paths.shuffle()
	var path_size : int = create_levels.all_paths.size()
	if path_size > size:
		path_size = size
	for i in path_size:
		var scene = Node2D.new()
		scene.name = "Game_Template"
		var script = load("res://play_scenes/game_template.gd")
		scene.set_script(script)
		
		camera_zoom = camera_zoom.instance()
		scene.add_child(camera_zoom)
		camera_zoom.owner = scene

		for j in create_levels.all_paths[i].size():
			var new_block = block.instance()
			new_block.position = (create_levels.all_paths[i][j].pos + center_screen) * grid_size
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

# 		ResourceSaver.save("res://temp_play_scenes/3_3_7/level_" + String(i + 1) + ".tscn", toSave)
