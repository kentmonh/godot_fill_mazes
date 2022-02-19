extends Node2D

const locked = preload("res://assets/images/locked.png")
var dollar = preload("res://scenes/dollar.tscn")

var left_border = 10
var right_border = 300
var top_border = 80
var x = left_border
var y = top_border

func _ready():
	# Levels system
	# var max_level = 300
	var max_level = Player.unlock_levels[Player.level_category - 1]
	
	# Set dollar visible
	dollar = dollar.instance()
	dollar.position = Vector2(6.5, 0) * Global.grid_size
	add_child(dollar)
	dollar.visible = true
	
	# Setting buttons
	for button in self.get_children():
		if button.is_in_group('btn_levels'):
			button.get_node("Button").get("custom_fonts/font").set_size(12)
			var number = button.get_name().substr(20)

			# Set position
			if x > right_border:
				x = left_border
				y += 60
			button.position.x = x
			button.position.y = y
			x += 50
			
			# Levels system
			if int(number) <= max_level:
				button.get_node("Button").disabled = false
				button.get_node("Button").text = number
				button.get_node("Sprite_Lock").visible = false
			else:
				button.get_node("Button").disabled = true
				button.get_node("Button").text = ""
				button.get_node("Sprite_Lock").visible = true
				button.get_node("Sprite_Lock").modulate = Global.blackish
