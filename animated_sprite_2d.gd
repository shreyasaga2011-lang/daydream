extends Node2D

@export var flash_duration := 0.3
@export var detection_radius := 60  # distance from player to trigger flash
@export var jumpscare_sound: AudioStream = preload("res://jumpscare (1).wav")

var npc_id := "NPC1"  # unique ID for this NPC

var flash_rect: ColorRect
var canvas_layer: CanvasLayer
var audio_player: AudioStreamPlayer
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

	# Create AudioStreamPlayer for jumpscare
	audio_player = AudioStreamPlayer.new()
	audio_player.stream = jumpscare_sound
	add_child(audio_player)

func _process(delta):
	if activated:
		return

	var player_node = Global.player
	if player_node:
		var distance = global_position.distance_to(player_node.global_position)
		if distance <= detection_radius:
			activated = true
			do_jumpscare()

func do_jumpscare():
	# Play jumpscare sound immediately
	audio_player.play()

	# Optionally mute other sounds (but NOT the jumpscare)
	# AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)

	# Flash screen
	var tween = create_tween()
	tween.tween_property(flash_rect, "color", Color(.3, 0, 0, 1), flash_duration / 2)
	tween.tween_property(flash_rect, "color", Color(1, 1, 1, 0), flash_duration / 2).set_delay(flash_duration / 2)

	# Resume audio (if you muted other buses)
	tween.tween_callback(Callable(self, "_resume_audio")).set_delay(flash_duration)


func _resume_audio():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
