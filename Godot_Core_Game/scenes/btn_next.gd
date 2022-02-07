extends Node2D

var next_scene_path

func _ready():
	$Button.connect("pressed", self, "_on_Button_pressed")

func _on_Button_pressed():
	# Move to next level
	if Player.level < 300:
		Player.level += 1
		next_scene_path = "res://play_scenes/level_" + str(Player.level_category) + "/level_" + str(Player.level) + ".tscn"
	else:
		Player.level = 1
		Player.level_category += 1
		next_scene_path = "res://play_scenes/level_" + str(Player.level_category) + "/level_1.tscn"
	Global.goto_scene(next_scene_path)
