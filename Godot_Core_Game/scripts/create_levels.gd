# Use to find all paths (Use iteration instead recursion to avoid stackoverflow error).
tool
extends EditorScript
class_name CreateLevels

# For all the level (many paths in levels)
var level : Level
var all_paths : Array = []
var num_of_start_points : int
var options_2 : Array = [0, 1]

# For each different start point
var path_stack
var matrix_visit
var paths_in_start : Array = []
var max_options_in_start : int
var unique_paths_in_start : Array = []
var dup_positions : Array = []

# Begin of level
func _init():
	# Init variables
	level = Level.new(3, 1, 3)
	num_of_start_points = level.row_length * level.column_length

# Create matrix with false values (init matrix, do not visit any point)
func create_matrix(w, h):
	# Create matrix
	var map = []
	for x in w:
		var col = []
		col.resize(h)
		map.append(col)
	# Assign values
	for x in w:
		for y in h:
			map[x][y] = false
	return map

# Check 2 path stack have same content or not
func same_stack(stack_1, stack_2):
	for point_1 in stack_1:
		# var count : int = 0
		for i in stack_2.size():
			if point_1.pos == stack_2[i].pos:
				break
			else:
				if i == stack_2.size() - 1:
					return false
	return true
	
#func same_stack(stack_1, stack_2):
#	# Always same length
#	var count_stack_2 : int = 0
#	for point_1 in stack_1:
#		for point_2 in stack_2:
#			if point_2.pos == point_1.pos:
#				break
#			else:
#				count_stack_2 += 1
#			if count_stack_2 == stack_2.size():
#				return false
#	return true

# Valid move
func valid_move(next_point : Point):
	if next_point.row >= 0 && next_point.row < level.row_length \
	&& next_point.column >= 0 && next_point.column < level.column_length \
	&& matrix_visit[next_point.row][next_point.column] == false:
		return true
	else:
		return false

# Calculate the number of options around a point
func caluculate_options(point : Point) -> int:
	var options : int = 0
	for direction in point.next_to_points:
		var around_pos = point.pos + direction["direction"]
		var next_point = Point.new(around_pos.x, around_pos.y)
		if next_point.row >= 0 && next_point.row < level.row_length \
		&& next_point.column >= 0 && next_point.column < level.column_length \
		&& matrix_visit[next_point.row][next_point.column] == true:
			options += 1
	return options

# Calculate the total of options in a stack
func options_in_stack(stack : Array) -> int:
	var options_in_stack : int = 0
	for i in stack.size():
		options_in_stack += caluculate_options(stack[i])
	return options_in_stack

#var time_start = 0
#var time_now = 0
# Run
func _run():
#	time_start = OS.get_ticks_msec()
	for i in num_of_start_points:
		# print("INDEXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX IS " + String(i))
		paths_in_start.append([])
		unique_paths_in_start.append([])
		dup_positions.append([])
		start(i)
		
	for i in num_of_start_points:
		for j in paths_in_start[i].size():
			# Check duplicate all_paths_in_start[i][j] vs each array in all_paths
			var is_duplicated = false
			for k in all_paths.size():
				if same_stack(paths_in_start[i][j], all_paths[k]) == true:
					var rand_option = options_2[randi() % options_2.size()]
					if (rand_option == 1):
						all_paths[k] = paths_in_start[i][j]
					is_duplicated = true
					break

			# If not duplicated
			if is_duplicated == false:
				all_paths.append(paths_in_start[i][j])

#	time_now = OS.get_ticks_msec()
#	var time_elapsed = time_now - time_start
#	print("Time in improve compare " + String(time_elapsed))
	print("There are " + String(all_paths.size()) + " games in the level!")
#	for path in all_paths:
#		for point in path:
#			print(point.pos)
#		print("-----")

# Set a new start point
func start(index : int):
	# Set start point
	var x = index / level.column_length
	var y = index % level.column_length
	matrix_visit = create_matrix(level.row_length, level.column_length)
	path_stack = []
	max_options_in_start = 0
	var start = Point.new(x, y)
	path_stack.append(start)
	matrix_visit[x][y] = true
	SAW(index);


# Self Avoid Walk
func SAW(index : int):
	while path_stack.size() > 0:
		if path_stack.size() < level.distance:
			# Move
			move()
		elif path_stack.size() == level.distance:
			# Found a path
			found_path(index)
			backtracking()


# Found a path
func found_path(index : int):
	var options = options_in_stack(path_stack)
	if options < max_options_in_start - 4:
		return
	elif options > max_options_in_start:
		max_options_in_start = options
		for i in paths_in_start[index].size():
			if options_in_stack(paths_in_start[index][i]) < max_options_in_start - 4:
				paths_in_start[index].remove(i)
			if i >= paths_in_start[index].size():
				break
#		paths_in_start[index].clear()
#		unique_paths_in_start[index].clear()
#		dup_positions[index].clear()
	
	# Check duplicate
	var is_duplicated = false
	for i in unique_paths_in_start[index].size():
		if same_stack(path_stack, unique_paths_in_start[index][i]) == true:
			is_duplicated = true
			if !dup_positions[index].has(i):
				# Add the index to dup_positions[index]
				dup_positions[index].append(i)
				# Delete the duplicated path
				# var array_3 = []
				for j in paths_in_start[index].size():
					# Array_3 is coppied of each path in unique_paths_in_start
#					array_3.clear()
#					for l in paths_in_start[index][k].size():
#						array_3.append(paths_in_start[index][k][l].pos)
					if same_stack(path_stack, paths_in_start[index][j]) == true:
						paths_in_start[index].remove(j)
						break
			break

	# Array_2 is coppied of path_stack
#	var array_2 = []
#	array_2.clear()
#	for i in path_stack.size():
#		array_2.append(path_stack[i].pos)
#
#	for i in unique_paths_in_start[index].size():
#		# Array_1 is coppied of each path in unique_paths_in_start
#		var array_1 = []
#		array_1.clear()
#		for j in unique_paths_in_start[index][i].size():
#			array_1.append(unique_paths_in_start[index][i][j].pos)
#		if same_stack(array_1, array_2) == true:
#			is_duplicated = true
#			if !dup_positions[index].has(i):
#				# Add the index to dup_positions[index]
#				dup_positions[index].append(i)
#				# Delete the duplicated path
#				var array_3 = []
#				for k in paths_in_start[index].size():
#					# Array_3 is coppied of each path in unique_paths_in_start
#					array_3.clear()
#					for l in paths_in_start[index][k].size():
#						array_3.append(paths_in_start[index][k][l].pos)
#					if same_stack(array_2, array_3) == true:
#						paths_in_start[index].remove(k)
#						break
#			break

	var cloned_stack = path_stack.duplicate()
	# If not duplicated
	if is_duplicated == false:
		# var cloned_stack = path_stack.duplicate()
		paths_in_start[index].append(cloned_stack)
		unique_paths_in_start[index].append(cloned_stack)
		print("index " + String(index) + " size() " + String(unique_paths_in_start[index].size()))


# Still move, not found a path yet
func move():
	# Check neibours points
	var direction_checked = 0
	# Last point of stack
	var point = path_stack.back()
	for direction in point.next_to_points:
		if direction["block"] == false:
			var new_pos = point.pos + direction["direction"]
			var next_point = Point.new(new_pos.x, new_pos.y)
			if valid_move(next_point) == true:
				path_stack.append(next_point)
				matrix_visit[next_point.row][next_point.column] = true
				break
			else:
				direction_checked += 1
		# Blocked direction
		else:
			direction_checked += 1

	# No more way and do not finish yet, comeback
	if direction_checked == 4:
		backtracking()


func backtracking():
	# Pop the last point
	var pop_point = path_stack.pop_back()
	matrix_visit[pop_point.row][pop_point.column] = false
	
	if !path_stack.empty():
		# Block the direction
		var previous_point = path_stack.back()
		var block_direction = pop_point.pos - previous_point.pos
		for next_point in previous_point.next_to_points:
			if next_point["direction"] == block_direction:
			   next_point["block"] = true
			   break

		# Unblock all directions of pop point
		for next_point in pop_point.next_to_points:
			next_point["block"] = false
