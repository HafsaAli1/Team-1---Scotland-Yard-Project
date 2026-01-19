extends CharacterBody3D
@export var speed = 14
@export var fall_acceleration = 75
var target_velocity = Vector3.ZERO


func _physics_process(delta):
	var direction = Vector3.ZERO

	# Capture input for movement
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1

	# Normalize direction to prevent faster diagonal movement
	if direction != Vector3.ZERO:
		direction = direction.normalized()

	# Calculate ground velocity
	target_velocity.x = direction.x * speed

	# Apply gravity when not on the floor
	if not is_on_floor():
		target_velocity.y -= fall_acceleration * delta

	# Move the character
	velocity = target_velocity
	move_and_slide()
