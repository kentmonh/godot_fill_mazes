extends CanvasLayer

var camera = null

func _ready():
	$Menu_Up/Button_Up.set_focus_mode(0)
	$Menu_Down/Button_Down.set_focus_mode(0)
	camera = self.get_parent().get_node("Main_Camera")


func _on_Button_Up_pressed():
	camera.position -= Vector2(0, 600)


func _on_Button_Down_pressed():
	camera.position += Vector2(0, 600)
