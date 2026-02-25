extends Node

var values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
@onready var http_request := HTTPRequest.new()

func _ready():
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)
	
	var url = "http://trinity-developments.co.uk/games"
	var error = http_request.request(url)
	if error != OK:
		print("Request Maps Error: ", error)

func _on_request_completed(result, response_code, headers, body):
	
	if not is_inside_tree(): 
		return

	if response_code == 200:
		var json_string = body.get_string_from_utf8()
		var json_data = JSON.parse_string(json_string)
		
		if typeof(json_data) == TYPE_DICTIONARY:
			var games = json_data.get("games", []) 
			var gameIdArray = []
			
			for i in games:
				gameIdArray.append(i["gameId"])
			
			if gameIdArray.size() > 0:
				var gameSelect = gameIdArray.pick_random()
				
				
				if has_node("Label3"):
					$Label3.text = str(gameSelect)
				else:
					print("Error: Label3 not found in scene tree.")
		else:
			print("Failed to parse JSON.")

func _on_backbutton_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_startbutton_pressed():
	get_tree().change_scene_to_file("res://map_scene.tscn")
