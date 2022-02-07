extends Node2D

func _ready():
	# $Sprite_Background.modulate = Global.yellow
	$Sprite_Background.material.set_shader_param("block_color", Global.yellow)
	$Label.add_color_override("font_color", Global.blackish)
	$Label2.add_color_override("font_color", Global.blackish)
	$Sprite_Unlock.modulate = Global.blackish
	# $Sprite_Unlock.material.set_shader_param("block_color", Global.blackish)
	$Button_Unlock.set_focus_mode(0)
	$Button_Cancel.set_focus_mode(0)


func _on_Button_Unlock_pressed():
	if Player.money >= 1:
		Player.unlock_levels[Player.level_category - 1] = 1
		Player.money -= 1
		Player.save_level()
		Global.goto_scene("res://play_scenes/menu_select_level.tscn")


func _on_Button_Cancel_pressed():
	Global.goto_scene("res://play_scenes/menu_main.tscn")
