extends Node

var values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]

@onready var http_request := HTTPRequest.new()
func _ready():
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)
	
	var url = "http://trinity-developments.co.uk/games"
	var error = http_request.request(url)
	if error != OK:
		print("Request Maps: ", error,"\n")
func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var json_string = body.get_string_from_utf8()
		var json_data = JSON.parse_string(json_string)
		if typeof(json_data) == TYPE_DICTIONARY:
			print("JSON Data: ", json_data)
		else:
			print("Failed to parse JSON.")
		var games = json_data["games"]
		var gameIdArray = []
		for i in games:
			print("\n",i)
			gameIdArray.append(i["gameId"])
		print(gameIdArray)
		if gameIdArray != []:
			var gameSelect = gameIdArray.pick_random()
			#var label := Label.new()  # Create a new Label node
			$Label3.text = str(gameSelect)
