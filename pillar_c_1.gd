extends Node2D  # This script is for PillarC3

@export var color_name: String = "Green"   # Set the color for this pillar
@export var matching_pillars: Array[NodePath] = []  # Other linked pillars

@onready var base_sprite = $BaseSprite3
@onready var activation_area = $ActivationArea3

var activated = false
var player_in_area = false
var transitioned = false  # Ensures scene transition only happens once

func _ready():
	name = "PillarC3"

	if not base_sprite:
		push_error("BaseSprite3 missing in " + name)
		return
	if not activation_area:
		push_error("ActivationArea3 missing in " + name)
		return

	# Connect signals
	activation_area.body_entered.connect(_on_body_entered)
	activation_area.body_exited.connect(_on_body_exited)

	# Set initial dark color
	base_sprite.modulate = get_color_dark(color_name)

func _process(delta):
	if player_in_area and Input.is_action_just_pressed("interact") and not activated:
		activate()

func _on_body_entered(body):
	if body.name == "Player":
		player_in_area = true

func _on_body_exited(body):
	if body.name == "Player":
		player_in_area = false

func activate():
	if activated:
		return  # Prevent double activation
	activated = true

	# Brighten this pillar
	base_sprite.modulate = get_color_bright(color_name)

	# Activate matching pillars
	for path in matching_pillars:
		var pillar = get_node_or_null(path)
		if pillar and pillar.has_node("BaseSprite3"):
			pillar.get_node("BaseSprite3").modulate = get_color_bright(color_name)

	# Increment global count once
	Global.activated_pillars += 1
	print("Activated pillars: ", Global.activated_pillars)

	# Only transition once
	if Global.activated_pillars >= 3 and not transitioned:
		transitioned = true
		_do_scene_transition()

# Scene transition with smooth flash
func _do_scene_transition():
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 100
	get_tree().current_scene.add_child(canvas_layer)

	var flash_rect = ColorRect.new()
	flash_rect.color = Color(1,1,1,0)
	flash_rect.anchor_left = 0
	flash_rect.anchor_top = 0
	flash_rect.anchor_right = 1
	flash_rect.anchor_bottom = 1
	canvas_layer.add_child(flash_rect)

	var tween = create_tween()
	tween.tween_property(flash_rect, "color", Color(1,1,1,1), 0.3)
	tween.tween_property(flash_rect, "color", Color(1,1,1,0), 0.3).set_delay(0.3)
	tween.tween_callback(Callable(self, "_change_scene")).set_delay(0.6)

func _change_scene():
	get_tree().change_scene_to_file("res://backgroundlvl2.tscn")

# Dark version (inactive)
func get_color_dark(name: String) -> Color:
	match name:
		"Red": return Color(0.3, 0, 0)
		"Blue": return Color(0, 0, 0.3)
		"Green": return Color(0, 0.3, 0)
		_: return Color(0.3, 0.3, 0.3)

# Bright version (activated)
func get_color_bright(name: String) -> Color:
	match name:
		"Red": return Color(1, 0, 0)
		"Blue": return Color(0, 0, 1)
		"Green": return Color(0, 1, 0)
		_: return Color(1, 1, 1)
