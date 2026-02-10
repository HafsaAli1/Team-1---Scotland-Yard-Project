@tool
extends Node2D

@export var radius_x: float = 14.0
@export var radius_y: float = 14.0
@export var fill_color: Color = Color.WHITE
@export var outline_color: Color = Color.BLACK
@export var outline_width: float = 2.0

func _draw():
	# Save transform
	draw_set_transform(Vector2.ZERO, 0.0, Vector2(radius_x / radius_y, 1.0))

	# Filled circle (scaled into an oval)
	draw_circle(Vector2.ZERO, radius_y, fill_color)

	# Outline
	draw_circle(
		Vector2.ZERO,
		radius_y - outline_width / 2.0,
		outline_color
	)

	# Reset transform
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _process(_delta):
	if Engine.is_editor_hint():
		queue_redraw()
