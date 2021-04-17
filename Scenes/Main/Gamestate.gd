extends Node


var players = {}


func _ready():
	pass 


func RegisterPlayer(id, name):
	print("A new player " + str(id) + " : " + name + " has connected")
	players[id] = name
	return true


func UnregisterPlayer(id):
	players.erase(id)
	get_node("../" + str(id)).queue_free()


func FetchPlayerList():
	return players.values()


func FetchPlayerIds():
	return players.keys()


