extends Node

@export var total_buttons := 3
var activated_count := 0
var player

func _ready():
	player = $Player  # assign your player node here

func button_activate():
	activated_count += 1
	if activated_count >= total_buttons:
		go_to_next_scene()

func go_to_next_scene():
	get_tree().change_scene("res://NextScene.tscn")
