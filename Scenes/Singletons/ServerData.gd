extends Node


var game_data = {
	"GRAVITY": 500.0
}
var player_stats = {
	"max_health": 100,
	"health": 100
}
var spawn_position = {
	"0": [
		Vector2(-17, 434), 
		Vector2(1, 434),
		Vector2(22, 434),
		Vector2(45, 434)
	],
	"1": [
		Vector2(40, 369), 
		Vector2(60, 369), 
		Vector2(80, 369), 
		Vector2(100, 369), 
	],
	"2": [
		Vector2(-25, 687), 
		Vector2(-10, 687), 
		Vector2(5, 687), 
		Vector2(20, 687), 
	],
	"3": [
		Vector2(40, 369), 
		Vector2(60, 369), 
		Vector2(80, 369), 
		Vector2(100, 369), 
	]
}


func GetPlayerSpawnPosition(level):
	return spawn_position[str(level)]


func _ready():
#	var game_data_file = File.new()
#	game_data_file.open("res://Data/game_data.json", File.READ)
#	var game_data_json = JSON.parse(game_data_file.get_as_text())
#	game_data_file.close()
#	game_data = game_data_json.result
	pass
