extends Node2D

var MAX_LEVEL = 300
var next_scene_path

func _ready():
	self.get_node("Sprite_Video").modulate = Global.blackish
	self.get_node("Button").set_focus_mode(0)

func _on_Button_pressed():	
	print("Next Pressed")



