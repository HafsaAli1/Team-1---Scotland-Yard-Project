extends CharacterBody3D

@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D
const speed = 5.0

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	_set_animation()

	move_and_slide()
func _set_animation():
	if velocity.z > 0.1:
		for i in range(1):
			velocity.z = 0
			animated_sprite_3d.play("turnRight")
		animated_sprite_3d.play("MoveRight")
	if velocity.z < -0.1:
		for i in range(1):
			velocity.z = 0
			animated_sprite_3d.play("turnLeft")
		animated_sprite_3d.play("MoveLeft")
	if velocity.z == 0:
		animated_sprite_3d.play("Idle")
