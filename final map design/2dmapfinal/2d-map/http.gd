extends Node

@onready var http_request := HTTPRequest.new()
var players = [1, 2, 3, 4, 5]
var starting_locations = {}
var minimum_distance = 10
var roles = {}

func _ready():
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)
	
	var url = "http://trinity-developments.co.uk/maps/101"
	var error = http_request.request(url)
	if error != OK:
		print("Request Maps: ", error,"\n")
		createGame()
func createGame():
	var url = "http://trinity-developments.co.uk/games"
	var error = http_request.request(url)
	if error != OK:
		print("Request Games: ", error)
func assign_roles():
	var random_index = randi() % players.size()
	var mr_x_player = players[random_index]
	
	for player in players:
		if player == mr_x_player:
			roles[player] = "Mr X"
		else:
			roles[player] = "Detective"


func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var json_string = body.get_string_from_utf8()
		var json_data = JSON.parse_string(json_string)
		
		var locations = json_data["locations"]
		var random_locations = []
		
		while random_locations.size() < 5:
			var index = randi() % locations.size()
			var location_number = locations[index]["location"]
			
			var valid = true
			for existing in random_locations:
				if abs(existing - location_number) < minimum_distance:
					valid = false
					break
			
			if valid and location_number not in random_locations:
				random_locations.append(location_number)
		
		for i in range(players.size()):
			starting_locations[players[i]] = random_locations[i]
		
		assign_roles()
		
		for player_id in players:
			print("Player ", player_id,
			" starts at location ", starting_locations[player_id],
			" and is ", roles[player_id])
		
		if typeof(json_data) == TYPE_DICTIONARY:
			print("JSON Data: ", json_data)
		else:
			print("Failed to parse JSON.")
	else:
		print("HTTP Error: ", response_code)
	
