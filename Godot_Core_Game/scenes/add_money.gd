extends Node2D
	
func _ready():
	self.get_node("Label").text = "+10"
	self.get_node("Label").modulate = Global.yellow
	# self.get_node("Label").add_color_override("font_color", Global.yellow)
	self.get_node("Sprite").modulate = Global.yellow
