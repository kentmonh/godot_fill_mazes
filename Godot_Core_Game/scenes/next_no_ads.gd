extends Node2D

var MAX_LEVEL = 300
var next_scene_path

func _on_Button_pressed():
	# Add 10 dollars
	Player.money += 10
	# Save level to save the money
	Player.save_level()
	
	# Move to next level
	if Player.level < 300:
		Player.level += 1
		next_scene_path = "res://play_scenes/level_" + str(Player.level_category) + "/level_" + str(Player.level) + ".tscn"
	else:
		Player.level = 1
		Player.level_category += 1
		next_scene_path = "res://play_scenes/level_" + str(Player.level_category) + "/level_1.tscn"
	Global.goto_scene(next_scene_path)
