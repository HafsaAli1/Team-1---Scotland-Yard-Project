extends Node

@onready var http_request := HTTPRequest.new()

func _ready():
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)

	var url = "http://trinity-developments.co.uk/maps/101"
	var error = http_request.request(url)
	if error != OK:
		print("Request error: ", error)
func createGame():
	var url = "http://trinity-developments.co.uk/games"
	var error = http_request.request(url)
	if error != OK:
		print("Request error: ", error)
		var Mapurl = "http://trinity-developments.co.uk/maps/101"
		var Maperror = http_request.request(url)
		if Maperror != OK:
			print("Request error: ", Maperror)

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var json_string = body.get_string_from_utf8()
		var json_data = JSON.parse_string(json_string)
		if typeof(json_data) == TYPE_DICTIONARY:
			print("JSON Data: ", json_data)
		else:
			print("Failed to parse JSON.")
	else:
		print("HTTP Error: ", response_code)
