extends Node2D

func _ready():
	self.get_node("Button").set_focus_mode(0)

func _on_Button_pressed():
	var level_category = int(self.get_node("Button").text.substr(6))
	Player.level_category = level_category
	if Player.unlock_levels[level_category - 1] > 0:
		Global.goto_scene("res://play_scenes/menu_select_level.tscn")
	else:
		Global.goto_scene("res://play_scenes/unlock_category.tscn")
