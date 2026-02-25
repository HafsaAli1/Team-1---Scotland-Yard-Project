extends Node

class LobbyPlayer:
	var name:String
	var player_id:int
	func _init(_name:String, _player_id:int):
		name = _name
		player_id = _player_id
		
var players:Array = []
var max_players:int = 6
var min_players:int = 3

var game_started:bool = false

# PLAYER JOINING

func player_join(player_name:String) -> bool:
	if game_started:
		return false
	
	if players.size() >= max_players:
		print("Too many players, please choose a different session")
		return false
		
	var new_player = LobbyPlayer.new(player_name, players.size())
	players.append(new_player)
	return true

func _name_exists(name:String) -> bool:
	for p in players:
		if p.name == name:
			return true
	
	return false
	
# PLAYER LEAVING

func remove_player(player_name:String):
	for i in range(players.size()):
		if players[i].name == player_name:
			players.remove_at(i)
			break
