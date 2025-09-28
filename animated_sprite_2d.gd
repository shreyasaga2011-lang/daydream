extends Node2D

@export var flash_duration := 0.3
@export var detection_radius := 45  # distance from player to trigger flash
var npc_id := "NPC1"  # unique ID for this NPC

var flash_rect: ColorRect
var canvas_layer: CanvasLayer
var activated := false

func _ready():
	# Create CanvasLayer so flash is on top
	canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 100
	add_child(canvas_layer)

	# Fullscreen white overlay (transparent initially)
	flash_rect = ColorRect.new()
	flash_rect.color = Color(1, 1, 1, 0)
	flash_rect.anchor_left = 0
	flash_rect.anchor_top = 0
	flash_rect.anchor_right = 1
	flash_rect.anchor_bottom = 1
	flash_rect.offset_left = 0
	flash_rect.offset_top = 0
	flash_rect.offset_right = 0
	flash_rect.offset_bottom = 0
	canvas_layer.add_child(flash_rect)

func _process(delta):
	if activated:
		return

	var player_node = Global.player
	if player_node:
		var distance = global_position.distance_to(player_node.global_position)
		if distance <= detection_radius:
			activated = true
			screen_flash()

func screen_flash():
	if not is_instance_valid(flash_rect) or flash_rect.color.a > 0:
		return

	var tween = create_tween()
	# Fade to white
	tween.tween_property(flash_rect, "color", Color(1,1,1,1), flash_duration/2)
	# Fade back to transparent
	tween.tween_property(flash_rect, "color", Color(1,1,1,0), flash_duration/2).set_delay(flash_duration/2)
