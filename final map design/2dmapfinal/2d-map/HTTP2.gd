extends Node

var values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]

@onready var http_request := HTTPRequest.new()
@onready var button = $Button
var check: bool = true
func _ready():
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)
	
	var url = "http://trinity-developments.co.uk/games"
	var error = http_request.request(url)
	if error != OK:
		print("error: ", error,"\n")
	button.pressed.connect(_on_button_pressed)
func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var json_string = body.get_string_from_utf8()
		var json_data = JSON.parse_string(json_string)
		var json_resturn: JSON = json_data
		if typeof(json_data) == TYPE_DICTIONARY:
			print("JSON Data: ", json_data)
		else:
			print("Failed to parse JSON.")
		if check == true:
			var gameIdArray = []
			for i in json_data["games"]:
				print("\n",i)
				gameIdArray.append(i["gameId"])
			print(gameIdArray)
			if gameIdArray != []:
				var gameSelect = gameIdArray.pick_random()
				$Label3.text = str(int(gameSelect))
				check = false
		else:
			print(json_data)
		
			
func _on_button_pressed():
	var headers = ["Content-Type: application/json"]
	var url = "http://trinity-developments.co.uk/games" % [$Label3.text]
	var data = {"gameId":$Label3.text,"mapId":101,"state":"Open","winner":"None","round":0,"length":13,"players":[]}
	var error = http_request.request(url,headers,HTTPClient.METHOD_POST,)
	if error != OK:
		print("Request Maps: ", error,"\n")
