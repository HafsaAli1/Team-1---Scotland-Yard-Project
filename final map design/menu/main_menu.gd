extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://games_menu.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://games_menu.tscn")


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://panel.tscn")


func _on_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	pass # Replace with function body.
