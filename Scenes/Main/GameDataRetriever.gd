extends Node


func FetchGameData(data_name, requester):
	return ServerData.game_data[data_name]
