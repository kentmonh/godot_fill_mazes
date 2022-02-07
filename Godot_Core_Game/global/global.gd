# Set global variables and events
extends Node2D

# Colors
var white = Color8( 255 , 255 , 255 , 255 )
var yellow = Color8( 255 , 223 , 108 , 255 )
var gray = Color8( 112 , 112 , 112 , 255 )
var dark = Color8( 63 , 63 , 63 , 255 )
var blackish = Color8( 32 , 32 , 32 , 255 )

var grid_size = 40
var current_scene = null


func _ready():
	# Vảariables for change scenes
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
	# Set background color
	VisualServer.set_default_clear_color(blackish)

# Link references:
# https://docs.godotengine.org/en/stable/getting_started/step_by_step/singletons_autoload.html
func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
