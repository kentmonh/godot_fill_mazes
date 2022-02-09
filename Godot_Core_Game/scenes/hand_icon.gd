extends Node2D

func _ready():
	scale = Vector2(0.7, 0.7)
#	position = Vector2(180 - 40 - 10, 320)
	var tween = get_node("Sprite_Hand/Tween")
	tween.repeat = true
	tween.interpolate_property(self, "position", Vector2(180 - 40 - 20, 320), Vector2(180 + 40 - 10, 320), 2, Tween.TRANS_CIRC, Tween.EASE_OUT)
	tween.start()

# Disable tutorial if player finish level 1
func _process(delta):
	if self.get_parent().path_get().size() == 3:
		self.queue_free()
