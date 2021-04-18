extends Node

var network = NetworkedMultiplayerENet.new()
var port = 10567
var max_players = 4


onready var player_verification_process = get_node("PlayerVerification")
onready var Gamestate = get_node("Gamestate")
onready var GameDataRetriever = get_node("GameDataRetriever")


var player_state_collection = {}


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
		player_state_collection.erase(player_id)
	print("User " + str(player_id) + " Disconnected")


remote func FetchGameData(requester):
	var player_id = get_tree().get_rpc_sender_id()
	var data = GameDataRetriever.FetchGameData()
	print("sending " + str(data) + " to player " + str(player_id)) 
	rpc_id(player_id, "ReturnGameData", data, requester)


remote func JoinRequest(username):
	print("Join request from " + str(username))
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


remote func SignalGameStart(level):
	print("Signaling game start")
	var s_spawn_positions = Gamestate.GetPlayerSpawnPosition(str(level))
	rpc_id(0, "ReturnGameStart", s_spawn_positions)


remote func ReceivePlayerState(player_state):
	var player_id = get_tree().get_rpc_sender_id()
	if player_state_collection.has(player_id):
		if player_state_collection[player_id]["T"] < player_state["T"]:
			player_state_collection[player_id] = player_state
	else:
		player_state_collection[player_id] = player_state


func SendWorldState(world_state):
	rpc_unreliable_id(0, "ReceiveWorldState", world_state)


