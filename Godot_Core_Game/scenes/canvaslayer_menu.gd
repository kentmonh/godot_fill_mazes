extends CanvasLayer

var camera = null
var limit_bottom : int

func _ready():
	$Menu_Up/Button_Up.set_focus_mode(0)
	$Menu_Down/Button_Down.set_focus_mode(0)
	camera = self.get_parent().get_node("Main_Camera")
	
	# Limit bottom in choose level scene
	if self.get_parent().name == "Menu_Select_Level":
		limit_bottom = 80 + 60 * 50 + 60
	else:
		# Limit bottom in choose category scene
		var last_button = self.get_owner().get_child(self.get_owner().get_child_count()-1)
		limit_bottom = last_button.position.y + Global.grid_size * 2 + 50

func _on_Button_Up_pressed():
	camera.position -= Vector2(0, 600)
	camera.limit_camera(limit_bottom)

func _on_Button_Down_pressed():
	camera.position += Vector2(0, 600)
	camera.limit_camera(limit_bottom)
