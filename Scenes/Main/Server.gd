extends Node

var network = NetworkedMultiplayerENet.new()
var port = 10567
var max_players = 4


func _ready():
	StartServer()


func StartServer():
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	print("Server started")
	
	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")
	

func _Peer_Connected(player_id):
	print("User " + str(player_id) + " Connected")


func _Peer_Disconnected(player_id):
	get_node("Gamestate").UnregisterPlayer(player_id)
	print("User " + str(player_id) + " Disconnected")


remote func FetchGameData(data_name, requester):
	var player_id = get_tree().get_rpc_sender_id()
	var data = get_node("GameDataRetriever").FetchGameData(data_name)
	print("sending " + str(data_name) + " : " + str(data) + " to player " + str(player_id)) 
	rpc_id(player_id, "ReturnGameData", data_name, data, requester)


remote func JoinRequest(username):
	var player_id = get_tree().get_rpc_sender_id()
	var result = get_node("Gamestate").RegisterPlayer(player_id, username)
	rpc_id(player_id, "ReturnJoinRequest", result)
	SignalPlayerListRefresh()


remote func FetchPlayerList(requester):
	var player_id = get_tree().get_rpc_sender_id()
	var players = get_node("Gamestate").FetchPlayerList()
	rpc_id(player_id, "ReturnPlayerList", players, requester)


func SignalPlayerListRefresh():
	print("Notifying other players of new player connection")
	var players = get_node("Gamestate").FetchPlayerList()
	var player_ids = get_node("Gamestate").FetchPlayerIds()
	for player_id in get_node("Gamestate").FetchPlayerIds():
		rpc_id(player_id, "SignalPlayerListRefresh", players)

