# A Game template
extends Node2D

var canvaslayer = preload("res://scenes/canvaslayer_game.tscn")

var around = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]

# Variables of each game
# Number of goals on level
var num_of_unsolved_blocks setget blocks_set, blocks_get
var path = [] setget path_set, path_get

# Variables for finish the level
var num_of_blocks : int
var MAX_LEVEL = 300
var timer = null


func _ready():
	# Set canvaslayer
	canvaslayer = canvaslayer.instance()
	add_child(canvaslayer)
	# Load money at each game play (after add)
	Player.load_level()
	# init
	initialize()


# Set init gameplay
func initialize():
	if self.get_node("Block"):
		var init_block = self.get_node("Block")
		init_block.occupied = true
		init_block.current = true
		# init_block.get_node("Sprite").modulate = Global.yellow
		init_block.get_node("Sprite").material.set_shader_param("block_color", Global.yellow)
		
		# Find availables around
		var availables = []
		for direction in around:
			availables.append(init_block.position + direction * Global.grid_size)
		# Set available for the next to blocks
		for block in self.get_children():
			if block.is_in_group("blocks"):
				num_of_blocks += 1
				if availables.has(block.position):
					block.available = true
				
		# Set path
		path_add(init_block)
	
	# Set number of blocks
	var blocks = 0
	for block in self.get_children():
		if block.is_in_group('blocks') && !block.occupied:
			# Set color
			# block.get_node("Sprite").modulate = Global.gray
			block.get_node("Sprite").material.set_shader_param("block_color", Global.gray)
			blocks += 1
	blocks_set(blocks)


func blocks_set(num_blocks):
	num_of_unsolved_blocks = num_blocks

func blocks_get():
	return num_of_unsolved_blocks

func path_set(_path):
	path = _path

func path_get():
	return path

func path_add(ele):
	path.append(ele)

func _process(delta):
	if (path_get().size() == num_of_blocks):
		finish_level()

# Player win the level
var path_get_index : int = 0

func finish_level():
	# Stop process
	set_process(false)

	# Add money
	Player.money += 1
	# Unlock the next level
	# if Player.level == Player.unlock_levels[Player.level_category - 1]:
	if Player.unlock_levels[Player.level_category - 1] < MAX_LEVEL:
		if Player.level == Player.unlock_levels[Player.level_category - 1]:
			Player.unlock_levels[Player.level_category - 1] += 1
	else:
		Player.unlock_levels[Player.level_category] = 1
		
	# Save level each time finish level
	Player.save_level()
	
	# Disconnect input_event to prevent player click to maze after finish level
	for block in self.get_children():
		if block.is_in_group('blocks'):
			block.disconnect("input_event", block, "_on_Block_input_event")

	# Change color
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "_on_Timer_timeout")
	if num_of_blocks < 10:
		timer.set_wait_time(float(0.8) / num_of_blocks)
	elif num_of_blocks < 20:
		timer.set_wait_time(float(1.2) / num_of_blocks)
	elif num_of_blocks < 35:
		timer.set_wait_time(float(2) / num_of_blocks)
	elif num_of_blocks < 50:
		timer.set_wait_time(float(2.5) / num_of_blocks)
	else:
		timer.set_wait_time(float(3) / num_of_blocks)
	timer.set_one_shot(false) # Make sure it loops
	timer.start()

func _on_Timer_timeout():
	if path_get_index < num_of_blocks - 1:
		# Update the draw function
		update()
		path_get()[num_of_blocks - 1 - path_get_index].get_node("Sprite").material.set_shader_param("block_color", Global.dark)
		path_get_index += 1
	else:
		timer.stop()
		# Visible the next buttons
		canvaslayer.next.visible = true


# Draw line between blocks
func _draw():
	if path_get_index > 0:
		for i in path_get().size() - 1 - path_get_index:
			draw_line(path[i].position + Vector2(Global.grid_size / 2, Global.grid_size / 2), path[i + 1].position + Vector2(Global.grid_size / 2, Global.grid_size / 2), Global.blackish, 2)
		for i in range(path_get().size() - 1 - path_get_index, path_get().size() - 1):
			draw_line(path[i].position + Vector2(Global.grid_size / 2, Global.grid_size / 2), path[i + 1].position + Vector2(Global.grid_size / 2, Global.grid_size / 2), Global.yellow, 2)
		if path_get_index >= num_of_blocks: 
			for block in self.get_children():
				if block.is_in_group('blocks'):
					# Set color to yellow and dark
					if block.name == "Block":
						block.get_node("Sprite").material.set_shader_param("block_color", Global.yellow)
					else:
						block.get_node("Sprite").material.set_shader_param("block_color", Global.dark)
	elif (path_get().size() > 1):
		# draw_line(path[path_get().size() - 1].position + Vector2(Global.grid_size / 2, Global.grid_size / 2), path[path_get().size() - 2].position + Vector2(Global.grid_size / 2, Global.grid_size / 2), Global.blackish, 2)
		for i in path_get().size() - 1:
			draw_line(path[i].position + Vector2(Global.grid_size / 2, Global.grid_size / 2), path[i + 1].position + Vector2(Global.grid_size / 2, Global.grid_size / 2), Global.blackish, 2)
