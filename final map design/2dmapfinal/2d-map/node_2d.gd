extends Node2D

func _ready():
	# redraw immediately when the node enters the scene
	_draw_circle()

func _draw_circle():
	draw_circle(Vector2.ZERO, 50, Color.WHITE)  # radius 50, red
