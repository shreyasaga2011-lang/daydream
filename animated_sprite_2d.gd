extends Node2D

@export var activation_delay := 0.5  # seconds before NPC triggers
@export var flash_duration := 0.3    # seconds for fade in/out

var activated := false
var flash_rect: ColorRect
var canvas_layer: CanvasLayer

func _ready():
	# Create CanvasLayer so the flash is on top of everything
	canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 100
	add_child(canvas_layer)

	# Create fullscreen white overlay (transparent initially)
	flash_rect = ColorRect.new()
	flash_rect.color = Color(1, 1, 1, 0)  # fully transparent

	# Stretch to cover the entire screen
	flash_rect.anchor_left = 0
	flash_rect.anchor_top = 0
	flash_rect.anchor_right = 1
	flash_rect.anchor_bottom = 1
	flash_rect.offset_left = 0
	flash_rect.offset_top = 0
	flash_rect.offset_right = 0
	flash_rect.offset_bottom = 0

	canvas_layer.add_child(flash_rect)

	# Automatically activate after a delay
	await get_tree().create_timer(activation_delay).timeout
	activate()

func activate():
	if activated:
		return
	activated = true
	screen_flash()

func screen_flash():
	# Prevent double running
	if not is_instance_valid(flash_rect) or flash_rect.color.a > 0:
		return

	var tween = create_tween()
	# Fade screen to white in flash_duration seconds
	tween.tween_property(flash_rect, "color", Color(1, 1, 1, 1), flash_duration / 2)
	# Fade back to transparent
	tween.tween_property(flash_rect, "color", Color(1, 1, 1, 0), flash_duration / 2).set_delay(flash_duration / 2)
