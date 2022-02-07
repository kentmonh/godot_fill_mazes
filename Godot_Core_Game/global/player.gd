# Set global variables and events for each player
extends Node2D

var level_category = 0
var level = 0

# 21 stages
var unlock_levels = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var money = 0

const SAVE_PATH = "user://save-data.save"

func save_data():
	var save_dict = {
		'level': unlock_levels,
		'money': money
	}
	return save_dict


# Save
func save_level():
	var save_file = File.new()
	save_file.open(SAVE_PATH, File.WRITE)
	save_file.store_var( save_data() )
	save_file.close()


# Load
func load_level():
	var save_file = File.new()
	if not save_file.file_exists(SAVE_PATH):
		print("Aborting, no savefile")
		return
	else:
		save_file.open(SAVE_PATH, File.READ)
		var data = save_file.get_var()
		unlock_levels = data['level']
		money = data["money"]
		save_file.close()
