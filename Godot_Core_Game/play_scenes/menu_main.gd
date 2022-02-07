extends Node2D

var dollar = preload("res://scenes/dollar.tscn")

func _ready():
	# This code used for delete save file when testing
#	var dir = Directory.new()
#	dir.remove("user://save-data.json")

	# Load levels at init
	Player.load_level()
	
	# Set dollar visible
	dollar = dollar.instance()
	dollar.position = Vector2(6.5, 0) * Global.grid_size
	add_child(dollar)
	dollar.visible = true
	
	# Set button text
	for button in self.get_children():
		if button.is_in_group('btn_select_category'):
			# Set text of button
			var category = button.get_name().substr(23)
			var int_category = int(category)
			var text_level = "Level " + category
			var label_text = "Locked"
#			if Player.unlock_levels[int_category - 1] > 0:
			label_text = str(Player.unlock_levels[int_category - 1]) + " / 300"
			button.get_node("Button").text = text_level
			button.get_node("Label").text = label_text
			button.get_node("Button").disabled = false
