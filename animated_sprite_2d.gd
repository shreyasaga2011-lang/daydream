extends Node2D

@export var flash_duration := 0.3    # seconds for fade in/out
@export var detection_radius := 100  # radius around NPC to detect player

var flash_rect: ColorRect
var canvas_layer: CanvasLayer
var player_in_area := false
var activated := false

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

	# Create detection area
	var area = Area2D.new()
	var shape = CircleShape2D.new()
	shape.radius = detection_radius
	var collision = CollisionShape2D.new()
	collision.shape = shape
	area.add_child(collision)
	add_child(area)

	# Connect signals to detect player
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player" and not activated:
		player_in_area = true
		activated = true
		screen_flash()

func _on_body_exited(body):
	if body.name == "Player":
		player_in_area = false

func screen_flash():
	# Prevent double running
	if not is_instance_valid(flash_rect) or flash_rect.color.a > 0:
		return

	var tween = create_tween()
	# Fade screen to white
	tween.tween_property(flash_rect, "color", Color(1, 1, 1, 1), flash_duration / 2)
	# Fade back to transparent
	tween.tween_property(flash_rect, "color", Color(1, 1, 1, 0), flash_duration / 2).set_delay(flash_duration / 2)
