extends Camera2D

func _ready():
	limit_left = 0
	limit_top = 0
	limit_right = 360
	# Limit bottom in choose level scene
	if self.get_parent().name == "Menu_Select_Level":
		limit_bottom = 80 + 60 * 50 + 10
	else:
		# Limit bottom in choose category scene
		var last_button = self.get_owner().get_child(self.get_owner().get_child_count()-1)
		limit_bottom = last_button.position.y + Global.grid_size * 2
	position.x = 180
	position.y = 320


var events = {}
func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			events[event.index] = event
		else:
			events.erase(event.index)
	if event is InputEventScreenDrag:
		events[event.index] = event
		if events.size() == 1:
			position -= event.relative.rotated(rotation)
			limit_camera(limit_bottom)

func limit_camera(limit_bottom):
	if (position.y < 320):
		position.y = 320
	if (position.y > limit_bottom - 320):
		position.y = limit_bottom - 320
