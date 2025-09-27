extends CharacterBody2D

@export var movement_speed: float = 60.0
var character_direction: Vector2 = Vector2.ZERO
var last_facing_direction: String = "Right"  # Track last facing direction

enum States { IDLE, MOVE }
var currentState = States.IDLE

func _physics_process(delta: float) -> void:
	handle_state_transitions()
	perform_state_actions(delta)
	move_and_slide()


func handle_state_transitions() -> void:
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		currentState = States.MOVE
	else:
		currentState = States.IDLE


func perform_state_actions(delta: float) -> void:
	match currentState:
		States.MOVE:
			character_direction.x = Input.get_axis("ui_left", "ui_right")
			character_direction.y = Input.get_axis("ui_up", "ui_down")
			character_direction = character_direction.normalized()

			# Set animation based on direction
			if character_direction.x < 0:
				$AnimatedSprite2D.play("walkLeft")
				last_facing_direction = "Left"
			elif character_direction.x > 0:
				$AnimatedSprite2D.play("walkRight")
				last_facing_direction = "Right"
			else:
				# Going vertically — play last facing direction
				if last_facing_direction == "Left":
					$AnimatedSprite2D.play("walkLeft")
				else:
					$AnimatedSprite2D.play("walkRight")

			velocity = character_direction * movement_speed

		States.IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, movement_speed * delta)

			if last_facing_direction == "Left":
				$AnimatedSprite2D.play("idleLeft")
			else:
				$AnimatedSprite2D.play("idleRight")
