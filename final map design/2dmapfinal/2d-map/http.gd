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
			var ticket_type = connection["ticket"]
			
			if not adjacency.has(a):
				adjacency[a] = {}
			if not adjacency.has(b):
				adjacency[b] = {}
			
			if not adjacency[a].has(b):
				adjacency[a][b] = []
			if not adjacency[b].has(a):
				adjacency[b][a] = []
			
			adjacency[a][b].append(ticket_type)
			adjacency[b][a].append(ticket_type)
		
		adjacency_with_tickets = adjacency
		
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
		player_positions = starting_locations.duplicate()
		start_game()
		
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
	

# MAIN GAMEPLAY LOGIC BELOW #

var player_positions = {}
var adjacency_with_tickets = {}
var current_player_index = 0
var current_player
var round_number = 1

func start_game():
	current_player = players[current_player_index]
	print("\n ===== SCOTLAND YARD GAME =====")
	print("Round: ", round_number)
	print_current_turn()
	

func print_current_turn():
	print("\n--------------------")
	print("Current Player: ", current_player, " (", roles[current_player], ")")
	print("Current Location: ", player_positions[current_player])
	print("Tickets: ", tickets)
	show_available_moves()


func next_turn():
	current_player_index += 1
	
	if current_player_index >= players.size():
		current_player_index = 0
		round_number += 1
		print("\n===== ROUND ", round_number, " =====")
	
	current_player = players[current_player_index]
	print_current_turn()


func move_to(destination):
	var location = player_positions[current_player]
	
	if not adjacency_with_tickets.has(location):
		print("Invalid move, please try again.")
		return
	
	if not adjacency_with_tickets[location].has(destination):
		print("Not Connected")
		return
	
	var transport_types = adjacency_with_tickets[location][destination]
	
	var used_ticket = null
	
	for ticket in transport_types:
		if tickets.has(ticket) and tickets[ticket] > 0:
			used_ticket = ticket
			break
			
		if used_ticket == null:
			print("No valid tickets for this move.")
			return
			
		tickets[used_ticket] -= 1
		
		player_positions[current_player] = destination
		
		print("Player ", current_player, " moved to ", destination, " using ", used_ticket)
		next_turn()
		

func show_available_moves():
	var location = player_positions[current_player]
	
	if not adjacency_with_tickets.has(location):
		print("No moves available.")
		return
		
	print("Connected Stations:")
	
	for destination in adjacency_with_tickets[location].keys():
		var transport_types = adjacency_with_tickets[location][destination]
		print(" - ", destination, " on ", transport_types)
	
	print("\nType move_to(station #) to move.")
