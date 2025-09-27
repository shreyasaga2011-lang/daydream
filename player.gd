extends CharacterBody2D

@export var movement_speed: float = 100.0

var last_facing_direction := "Right"  # Used for idle animations

func _physics_process(_delta: float) -> void:
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if input_vector != Vector2.ZERO:
		velocity = input_vector.normalized() * movement_speed

		# Handle animations based on direction
		if input_vector.x < 0:
			$AnimatedSprite2D.play("walkLeft")
			last_facing_direction = "Left"
		elif input_vector.x > 0:
			$AnimatedSprite2D.play("walkRight")
			last_facing_direction = "Right"
		else:
			# If only vertical movement, play last facing direction walk
			if last_facing_direction == "Left":
				$AnimatedSprite2D.play("walkLeft")
			else:
				$AnimatedSprite2D.play("walkRight")
	else:
		velocity = Vector2.ZERO

		if last_facing_direction == "Left":
			$AnimatedSprite2D.play("idleLeft")
		else:
			$AnimatedSprite2D.play("idleRight")

	move_and_slide()
<<<<<<< HEAD
	
	
<<<<<<< HEAD


@export var display_time: float = 3.0 # seconds to show the 
=======
>>>>>>> c8849d99492119214e6f53df00405274265dc2e2
=======
>>>>>>> 24cce8597e9eb893e005630286c027746f36ff87
