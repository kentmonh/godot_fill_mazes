extends Area2D

var occupied = false
var available = false
var current = false

var around = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]

# var MAX_LEVEL = 300

func _ready():
	# Connect signal
	if !self.is_connected("input_event", self, "_on_Block_input_event"):
		self.connect("input_event", self, "_on_Block_input_event")

func _on_Block_input_event(viewport, event, shape_idx):
	# Update the draw function in template
	self.get_owner().update()
	# InputEventScreenDrag for mobile swipe
	if event is InputEventScreenTouch || event is InputEventScreenDrag:
		if available && !occupied:
			occupied = true
			# self.get_node("Sprite").modulate = Global.yellow
			self.get_node("Sprite").material.set_shader_param("block_color", Global.yellow)
			set_current()
			
			# Set number of blocks
			var blocks = self.get_owner().blocks_get()
			blocks -= 1
			self.get_owner().blocks_set(blocks)
			# Add to path
			self.get_owner().path_add(self)
			
			# Done the level
#			if self.get_owner().blocks_get() == 0:
#				finish_level()
				
		elif occupied:
			while self != self.get_owner().path_get().back():
				var pop = self.get_owner().path_get().pop_back()
				pop.occupied = false
				# pop.get_node("Sprite").modulate = Global.gray
				pop.get_node("Sprite").material.set_shader_param("block_color", Global.gray)
				# Set number of blocks
				var blocks = self.get_owner().blocks_get()
				blocks += 1
				self.get_owner().blocks_set(blocks)
			
			set_current()


func set_current():
	# Remove the available and current
	for block in self.get_owner().get_children():
		if block.is_in_group('blocks'):
			block.current = false
			block.available = false
			
	# Then set current
	current = true
	# Find availables
	var availables = []
	for direction in around:
		availables.append(self.position + direction * Global.grid_size)
	# Set available for next to blocks
	for block in self.get_owner().get_children():
		if block.is_in_group('blocks') && availables.has(block.position):
			block.available = true
