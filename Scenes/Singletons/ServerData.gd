extends Node


var game_data
var player_stats = {
	"max_health": 100,
	"health": 100
}


func _ready():
	var game_data_file = File.new()
	game_data_file.open("res://Data/game_data.json", File.READ)
	var game_data_json = JSON.parse(game_data_file.get_as_text())
	game_data_file.close()
	game_data = game_data_json.result
