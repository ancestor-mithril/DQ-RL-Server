extends Node


var players = {}


func _ready():
	pass 


func RegisterPlayer(id, name):
	print("A new player " + str(id) + " : " + name + " has connected")
	players[id] = name
	return true


func UnregisterPlayer(id):
	print("Unregistering player with id " + str(id))
	players.erase(id)


func FetchPlayerList():
	print("Fetching player list")
	return players.values()


func FetchPlayerIds():
	print("Fetching player ids")
	return players.keys()

func GetPlayerSpawnPosition(spawn_positions):
	var player_data = {}
	var i = 0
	for player_id in players.keys():
		player_data[player_id] = {
			"name": players[player_id],
			"pos": spawn_positions[i]
		}
		i += 1
	return player_data
	
