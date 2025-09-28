extends Node

@export var total_buttons := 3
@export var next_scene_path := "res://backgroundlvl2.tscn"

var activated_count := 0
var flash_rect: ColorRect

func _ready():
	# Create a fullscreen white overlay (transparent at first)
	flash_rect = ColorRect.new()
	flash_rect.color = Color(1, 1, 1, 0) # white transparent
	flash_rect.size = get_viewport().get_visible_rect().size
	add_child(flash_rect)

func button_activate():
	activated_count += 1
	if activated_count >= total_buttons:
		flash_and_transition()

func _process(delta):
	if Global.activated_pillars == total_buttons:
		flash_and_transition()

func flash_and_transition():
	# Prevent double running
	if not is_instance_valid(flash_rect) or flash_rect.color.a > 0:
		return
	
	var tween = create_tween()

	# Fade screen to white in 0.3s
	tween.tween_property(flash_rect, "color", Color(1, 1, 1, 1), 0.3)

	# After fade, change scene
	tween.tween_callback(Callable(self, "_do_scene_change")).set_delay(0.3)

func _do_scene_change():
	get_tree().change_scene_to_file(next_scene_path)
