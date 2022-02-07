extends Node2D

func _ready():
	self.get_node("Button").set_focus_mode(0)

func _on_Button_pressed():
	Global.goto_scene("res://play_scenes/menu_main.tscn")
