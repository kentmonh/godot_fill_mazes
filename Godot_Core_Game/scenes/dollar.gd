extends Node2D
	
func _ready():
	# Load money at init
	Player.load_level()
	self.get_node("Label").text = str(Player.money)
	# self.get_node("Label").add_color_override("font_color", Global.yellow)
	# self.get_node("Sprite").modulate = Global.yellow
