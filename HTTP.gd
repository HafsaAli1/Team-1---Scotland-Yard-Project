extends Node3D


func _on_ready():
	$HTTPRequest.request_completed.connect(_on_request_completed)
	$HTTPRequest.request("http://trinity-developments.co.uk/games")
	$HTTPRequest.request_completed.connect(_on_request_completed)


func _on_request_completed():
	print("done")
