extends Node

var network = NetworkedMultiplayerENet.new()
var port = 10567
var max_players = 4


onready var player_verification_process = get_node("PlayerVerification")
onready var Gamestate = get_node("Gamestate")
onready var GameDataRetriever = get_node("GameDataRetriever")


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
	player_verification_process.start(player_id)
	rpc_id(0, "SpawnNewPlayer", player_id, Vector2(26, 425))


func _Peer_Disconnected(player_id):
	Gamestate.UnregisterPlayer(player_id)
	if has_node(str(player_id)):
		get_node(str(player_id)).queue_free()
		rpc_id(0, "DespawnPlayer", player_id)
	print("User " + str(player_id) + " Disconnected")


remote func FetchGameData(data_name, requester):
	var player_id = get_tree().get_rpc_sender_id()
	var data = GameDataRetriever.FetchGameData(data_name)
	print("sending " + str(data_name) + " : " + str(data) + " to player " + str(player_id)) 
	rpc_id(player_id, "ReturnGameData", data_name, data, requester)


remote func JoinRequest(username):
	var player_id = get_tree().get_rpc_sender_id()
	var result = Gamestate.RegisterPlayer(player_id, username)
	rpc_id(player_id, "ReturnJoinRequest", result)
	SignalPlayerListRefresh()


remote func FetchPlayerList(requester):
	var player_id = get_tree().get_rpc_sender_id()
	var players = Gamestate.FetchPlayerList()
	rpc_id(player_id, "ReturnPlayerList", players, requester)


func SignalPlayerListRefresh():
	print("Notifying other players of new player connection")
	var players = Gamestate.FetchPlayerList()
	var player_ids = Gamestate.FetchPlayerIds()
#	var connected_peers = Array(get_tree().get_network_connected_peers())
#	Error could be if player_id not in connected_peers.keys()
	for player_id in player_ids:
		rpc_id(player_id, "SignalPlayerListRefresh", players)


remote func FetchPlayerStats():
	var player_id = get_tree().get_rpc_sender_id()
	var player = get_node(str(player_id))
	if player == null:
		return 1  # Error?
	var player_stats = player.player_stats
	rpc_id(player_id, "ReturnPlayerStats", player_stats)


