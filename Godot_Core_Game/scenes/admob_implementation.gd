# Load and show banner right away
extends Node2D

onready var admob : AdMob = $AdMob

func _ready():
	admob.load_banner()
	admob.show_banner()


func _on_AdMob_banner_loaded():
	print("Admob - Banner Loaded")
