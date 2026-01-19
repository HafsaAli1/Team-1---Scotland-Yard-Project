extends CharacterBody3D

@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D
var direction = Vector3()
var speed = 200
func _physic_process(delta):
	direction = Vector3(0,0,0)
	if Input.is_key_pressed(KEY_W):
		#animated_sprite_3d.play("turnLeft")
		#animated_sprite_3d.play("MoveLeft")
		direction.x -= 1
	direction = direction.normalized()
	direction = direction * speed * delta
