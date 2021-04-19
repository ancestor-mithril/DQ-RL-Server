extends Node


var enemy_id_counter = 1
var enemy_maximum = 2
var enemy_types = ["Mob", "MobProjectile", "MobHomingProjectile", "GolemBoss"]
var enemy_spawn_points
var open_locations
var occupied_locations
var enemy_list = {}
var enemy_stats


func _ready():
	init_level_data("0")
	var timer = Timer.new()
	timer.wait_time = 1.5
	timer.autostart = true
	timer.connect("timeout", self, "SpawnEnemy")
	self.add_child(timer)


func init_level_data(level):
	level = str(level)
	enemy_spawn_points = ServerData.mob_position[level]
	enemy_stats = ServerData.mob_stats
	enemy_maximum = len(enemy_spawn_points)
	open_locations = []
	for i in range(enemy_maximum):
		open_locations.append(i)
	occupied_locations = {}


func SpawnEnemy():
	if enemy_list.size() >= enemy_maximum:
		pass
	else:
		randomize()
		var rng_location_index = randi() % open_locations.size()
		var enemy = enemy_spawn_points[open_locations[rng_location_index]]
		occupied_locations[enemy_id_counter] = open_locations[rng_location_index]
		open_locations.remove(rng_location_index)
		enemy_list[enemy_id_counter] = {
			"type": enemy["type"],
			"pos": enemy["pos"],
			"stats": enemy_stats[enemy["type"]],
			"state": "idle", 
			"time_out": 4
		}
		enemy_id_counter += 1
	for enemy in enemy_list.keys():
		if enemy_list[enemy]["state"] == "dead":
			if enemy_list[enemy]["time_out"] == 0:
				enemy_list.erase(enemy)
			else:
				enemy_list[enemy]["time_out"] -= 1


func NPCHit(enemy_id, damage):
	if not enemy_list.has(enemy_id):
		print("This is error of receiving data from already erased enemy")
		return 1
	if enemy_list[enemy_id]["stats"]["health"] <= 0:
		pass
	else:
		enemy_list[enemy_id]["stats"]["health"] -= damage
		if enemy_list[enemy_id]["stats"]["health"] <= 0:
			enemy_list[enemy_id]["state"] = "dead"
			open_locations.append(occupied_locations[enemy_id])
			occupied_locations.erase(enemy_id)
