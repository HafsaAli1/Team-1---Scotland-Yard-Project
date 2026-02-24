extends Node

@onready var http_request := HTTPRequest.new()
var players = [1, 2, 3, 4, 5]
var starting_locations = {}
var minimum_distance = 10
var roles = {}
var tickets = {"Taxi": 10, "Bus": 8, "Train": 4, "Black": 2}

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
		var connections = json_data["connections"]
		
		var adjacency := {}
		
		for connection in connections:
			var a = int(connection["locationA"])
			var b = int(connection["locationB"])
			
			if not adjacency.has(a):
				adjacency[a] = []
			if not adjacency.has(b):
				adjacency[b] = []
			
			adjacency[a].append(b)
			adjacency[b].append(a)
		
		var random_locations = []
		
		while random_locations.size() < players.size():
			var index = randi() % locations.size()
			var location_number = int(locations[index]["location"])
			
			var valid = true
			
			if location_number in random_locations:
				continue
			
			for existing in random_locations:
				if adjacency.has(existing) and location_number in adjacency[existing]:
					valid = false
					break
			
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
	
