class_name Point

# Member Variables
var row : int
var column : int
var next_to_points = []
var pos : Vector2
var is_visited : bool

# Class Constructor
func _init(x, y):
	row = x
	column = y
	pos = Vector2(x, y)
	next_to_points = [
		{"direction" : Vector2.RIGHT, "block" : false},		# Right
		{"direction" : Vector2.DOWN, "block" : false}, 		# Bottom	
		{"direction" : Vector2.LEFT, "block" : false},		# Left
		{"direction" : Vector2.UP, "block" : false}			# Top
	]
	is_visited = false
	
