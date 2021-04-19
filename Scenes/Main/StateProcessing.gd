extends Node


var world_state


func _physics_process(delta):
	if not get_parent().player_state_collection.empty():
		world_state = get_parent().player_state_collection.duplicate(true)
		for player in world_state.keys():
			world_state[player].erase("T")
		world_state["T"] = OS.get_system_time_msecs()
		world_state["Enemies"] = get_node("../Map").enemy_list
		get_parent().SendWorldState(world_state)
