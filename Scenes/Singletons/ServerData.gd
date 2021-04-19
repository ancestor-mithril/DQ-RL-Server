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

var mob_stats = {
	"Mob": {
		"health": 25,
		"default_speed": 65,
		"stagger_default" : 10,
		"stagger_health" : 10,
		"invincible" : false,
		"mana": 0,
	},
	"GolemBoss": {
		"health": 200,
		"default_speed": 100,
		"stagger_default" : 300,
		"stagger_health" : 300,
		"invincible" : false,
		"mana": 0,
	},
	"MobProjectile": {
		"health": 25,
		"default_speed": 20,
		"stagger_default" : 10,
		"stagger_health" : 10,
		"invincible" : false,
		"mana": 0,
	},
	"MobHomingProjectile": {
		"health": 25,
		"default_speed": 20,
		"stagger_default" : 10,
		"stagger_health" : 10,
		"invincible" : false,
		"mana": 0,
	}
}

var mob_position = {
	"0": [
		{
			"type": "Mob",
			"pos": Vector2(704, 279),
			"stats": mob_stats["Mob"],
			"follow": false
		},
		{
			"type": "Mob",
			"pos": Vector2(1148, 572),
			"stats": mob_stats["Mob"]
		},
		{
			"type": "Mob",
			"pos": Vector2(1764, 637),
			"stats": mob_stats["Mob"]
		},
		{
			"type": "Mob",
			"pos": Vector2(1890, 705),
			"stats": mob_stats["Mob"]
		},
		{
			"type": "MobProjectile",
			"pos": Vector2(2106, 625),
			"stats": mob_stats["MobProjectile"]
		}
	]
}


func GetPlayerSpawnPosition(level):
	return spawn_position[str(level)]


func _ready():
	mob_position["0"][0]["stats"]["health"] = 9999
#	var game_data_file = File.new()
#	game_data_file.open("res://Data/game_data.json", File.READ)
#	var game_data_json = JSON.parse(game_data_file.get_as_text())
#	game_data_file.close()
#	game_data = game_data_json.result
	pass
