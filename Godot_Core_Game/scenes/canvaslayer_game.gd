extends CanvasLayer

var back = preload("res://scenes/back.tscn")
var next = preload("res://scenes/btn_next.tscn")
var restart = preload("res://scenes/restart.tscn")
var dollar = preload("res://scenes/dollar.tscn")
var lbl_level_infor = preload("res://scenes/lbl_level_infor.tscn")

func _ready():
	# Set back button
	back = back.instance()
	back.position = Vector2(0, 0) * Global.grid_size
	add_child(back)
	back.visible = true
	
	# Set restart button
	restart = restart.instance()
	restart.position = Vector2(8, 0) * Global.grid_size
	add_child(restart)
	restart.visible = true
	
	# Set dollar visible
	dollar = dollar.instance()
	dollar.position = Vector2(6.5, 0) * Global.grid_size
	add_child(dollar)
	dollar.visible = true
	
	# Set label level information
	lbl_level_infor = lbl_level_infor.instance()
	lbl_level_infor.position  = Vector2(0, 0)
	# Using format string Godot
	var format_level_infor = "%s-%s"
	var actual_level_infor_string = format_level_infor % [Player.level_category, Player.level]
	lbl_level_infor.get_node("Label").text = actual_level_infor_string
	
	add_child(lbl_level_infor)
	lbl_level_infor.visible = true
	
	# Set next button
	next = next.instance()
	next.position = Vector2(2, 13) * Global.grid_size
	add_child(next)
	next.visible = false
