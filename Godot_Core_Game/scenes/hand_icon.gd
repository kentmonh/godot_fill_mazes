extends Node2D

func _ready():
	scale = Vector2(0.7, 0.7)
	position = Vector2(180, 320)
	
func move(target):
	var move_tween = get_node("Sprite_Hand/Tween")
	move_tween.interpolate_property(self, position, target, 3, Tween.TRANS_QUINT, Tween.EASE_OUT)
	move_tween.start()
	
	
