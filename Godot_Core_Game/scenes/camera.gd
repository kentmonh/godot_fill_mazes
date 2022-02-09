extends Camera2D

func _ready():
	limit_left = 0
	limit_top = 0
	limit_right = 360
	# Limit bottom in choose level scene
	if self.get_parent().name == "Menu_Select_Level":
		limit_bottom = 100 + 60 * 50 + 40
	else:
		# Limit bottom in choose category scene
		var last_button = self.get_owner().get_child(self.get_owner().get_child_count()-1)
		limit_bottom = last_button.position.y + Global.grid_size * 2 + 40
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
