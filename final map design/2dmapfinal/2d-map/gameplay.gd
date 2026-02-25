extends Sprite2D

# initiating Player class
class Player:
	var player_id:int
	var player_role:int
	var player_position:int
	var tickets:Dictionary
	var travel_log:Array = []
	
	func _init(_player_id:int, _player_role:int, _player_position: int, _tickets:Dictionary):
		player_id = _player_id
		player_role = _player_role
		player_position = _player_position
		tickets = _tickets
		
const Ticket_Map := {
	"Yellow": "Taxi",
	"Green": "Bus",
	"Red": "Train",
	"Black": "Black"
}

var players:Array = []
var current_player:int = 0
var board:Dictionary = {}

# initiating round / turn variables
var turn = 1
var round = 1
var reveal_rounds: Array[int] = [3, 8, 13, 18, 24]
var total_rounds = 24

# initiating player tickets
var mr_x_tickets = {
	"Taxi": 10,
	"Bus": 8,
	"Train": 4,
	"Black": 2,
	"Double": 2
}
var detective_tickets = {
	"Taxi": 10,
	"Bus": 8,
	"Train": 4
}

func get_mr_x() -> Player:
	for p in players:
		if p.player == 0:
			return p
	
	return null

# Building game board using JSON Data
func _add_connection(a:int, b:int, ticket:String) -> void:
	if not board.has(a):
		board[a] = {}
	
	if not board[a].has(ticket):
		board[a][ticket] = []
	
	if b not in board[a][ticket]:
		board[a][ticket].append(b)

func build_board(map_data:Dictionary) -> void:
	board.clear()
	
	for connection in map_data["connections"]:
		var a:int = int(connection["locationA"])
		var b:int = int(connection["locationB"])
		var raw_ticket:String = connection["ticket"]
		
		if not Ticket_Map.has(raw_ticket):
			continue
			
		var ticket:String = Ticket_Map[raw_ticket]
		
		_add_connection(a, b, ticket)
		_add_connection(b, a, ticket)

# Board Movement
func valid_moves(player:Player) -> Array:
	var moves:Array = []
	
	if not board.has(player.player_position):
		return moves
	
	for ticket in board[player.player_position]:
		if player.tickets.get(ticket, 0) <= 0:
			continue
		
		for destination in board[player.player_position][ticket]:
			if player.player_role == 1 and is_occupied_d(destination):
				continue
			
			moves.append({
				"destination": destination,
				"ticket": ticket
			})
	
	return moves

func move_player(player:Player, destination:int, ticket:String) -> void:
	player.tickets[ticket] -=1
	
	if player.player_role == 1:
		get_mr_x().tickets[ticket] += 1
	
	player.player_position = destination
	
	if player.player_role == 0:
		player.travel_log.append({
			"round": round,
			"ticket": ticket,
			"revealed": round in reveal_rounds,
			"location": destination if round in reveal_rounds else -1
		})

# Player location functions
func get_detective_pos() -> Array:
	var positions:Array = []
	for p in players:
		if p.player_role == 1:
			positions.append(p.player_position)
	return positions

func is_occupied_d(location:int) -> bool:
	for p in players:
		if p.player_role == 1 and p.player_position == location:
			return true
	return false

# Gameplay Loop
func next_turn() -> void:
	current_player += 1
	turn += 1
	
	if current_player >= players.size():
		current_player = 0
		round += 1
		
