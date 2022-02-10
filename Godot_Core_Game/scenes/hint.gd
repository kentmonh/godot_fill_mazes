extends Node2D

var game = null
var timer = null
var i : int = 0

func _ready():
	$Button.set_focus_mode(0)
	game = self.get_parent().get_parent()
	timer = Timer.new()
	add_child(timer)

func _on_Button_pressed():
#	game.get_node("Block2").get_node("Sprite").material.set_shader_param("block_color", Global.yellow)
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.set_wait_time(0.4)
	timer.set_one_shot(false) # Make sure it loops
	timer.start()
	
func _on_Timer_timeout():
	if i % 2 == 0:
		game.get_node("Block2").get_node("Sprite").material.set_shader_param("block_color", Global.yellow)
		game.get_node("Block3").get_node("Sprite").material.set_shader_param("block_color", Global.gray)
	else:
		game.get_node("Block2").get_node("Sprite").material.set_shader_param("block_color", Global.gray)
		game.get_node("Block3").get_node("Sprite").material.set_shader_param("block_color", Global.yellow)
	i += 1

func _process(delta):
	if game.path_get().size() == 2 && timer.is_stopped() == false:
		game.get_node("Block3").get_node("Sprite").material.set_shader_param("block_color", Global.gray)
		timer.stop()
