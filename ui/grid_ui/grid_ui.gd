extends Node2D
class_name grid_ui


#this class is going to use the signals from the simple select grid i lay out to move grid tiles around
#and modify the save files based on those files.

#so each event will be triggered by simple select button presses, but the actual data for the blocks will be stored in
#nodes in the scene.

#problem, i have the node 2d child array, which is cool. but i still need the adjacent space thing, for the bottom array.
#meaning that ill probably want a separate array for that. i think?

#so the grid works now. im pretty sure that the save stuff works too. so im going to link up the rest of the grid, or at least a good amount of it, 
#then test it a little more. and i should also set up however the player node will change. and start making options.


#TODO: load upgrade status from save file, have the placement of blocks affect save file correctly
#TODO: for some reason block_adj persists between loads. dunno why. clearing it on ready seems to work.
#TODO: since youre reusing functions the file will add block upgrades everytime the thing is reloaded. fix that
#TODO: decrement spare blocks when a spare is picked up


@export_group("grid info")
#main grid
@export var block_grid : Node2D				#stores all active blocks in 2d child array
@export var main_origin : Node2D			#marks the 0,0 point in the main grid
@export var block_adj : Array[Array]

#bottom grid
@export var spare_grid : Node2D				#stores all spare blocks as 2d child array
@export var top_origin : Node2D #for placement of spare parts
@export var held_block : block_node			#holds the currently held block

#sfx
@export var pick_up_sf : sf_link
@export var put_down_sf : sf_link

@export_group("ui")
@export var sim_select : simple_select
@export var hangar_scene : scene_link
@export var left_scene : scene_link
@export var grid_tutorial_label : Label
@export_group("","")


#region autoload
#autoloads
@onready var save_mi : save_manager = get_node("/root/save_manager_auto")
@onready var scene_mi : scene_manager = get_node("/root/scene_manager_auto")
@onready var block_mi : block_manager = get_node("/root/block_manager_auto")
@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")
#endregion

func _ready():
	#clear block_adj cause it doesnt close for some reason
	var x : int = 0
	var y : int = 0
	
	while x < block_adj.size():
		while y < block_adj[0].size():
			block_adj[x][y] = false
			y += 1
		x += 1
		y = 0

	print_adj()
	#place grid blocks from save file
	print("placing main blocks")
	#vector keys, string values for getting blocks
	for k in save_mi.file_01.block_dict.keys():
		if save_mi.file_01.block_dict[k] == "none":
			continue
		print(k)
		held_block = block_mi.block_dict[save_mi.file_01.block_dict[k]].instantiate()
		get_tree().get_root().add_child.call_deferred(held_block)
		print(k)
		put_down_main(k, false)
		
	print("finished with main blocks")
	
	#place spare blocks from save file
	for s in save_mi.file_01.spare_dict["shield_block"]:
		#for however many shield parts the player has, put down another one in the shield part spot
		held_block = block_mi.block_dict["shield_block"].instantiate()
		get_tree().get_root().add_child.call_deferred(held_block)
		put_down_spare(Vector2(0,0), false)
	
	for s in save_mi.file_01.spare_dict["laser_block"]:
		#for however many shield parts the player has, put down another one in the shield part spot
		held_block = block_mi.block_dict["laser_block"].instantiate()
		get_tree().get_root().add_child.call_deferred(held_block)
		put_down_spare(Vector2(1,0), false)
		
	for s in save_mi.file_01.spare_dict["power_block"]:
		#for however many shield parts the player has, put down another one in the shield part spot
		held_block = block_mi.block_dict["power_block"].instantiate()
		get_tree().get_root().add_child.call_deferred(held_block)
		put_down_spare(Vector2(2,0),false)
		
	#enable/disable tutorial message
	
	if save_mi.file_01.day == 0:
		grid_tutorial_label.set_visible(true)
	
	
func _input(event):
	if event.is_action_pressed("db_nine"):
		print_adj()
	
func pick_up_main(pos : Vector2i, use_value : bool):
	#parameter is just location i think.
	if block_grid.get_child(pos.x).get_child(pos.y).get_child_count() == 0:
		return
	
	#gets the block, removes it from the old place and adds it to the main tree
	held_block = block_grid.get_child(pos.x).get_child(pos.y).get_child(0)
	block_grid.get_child(pos.x).get_child(pos.y).remove_child(held_block)
	get_tree().get_root().add_child.call_deferred(held_block)
	
	#move the block to the icons position in sim_select
	held_block.global_position = sim_select.icon.global_position

	sfx_pi.play_effect(pick_up_sf)

	for s in held_block.block_info.grid_shape:
		#find each "cube" in the block_adj grid and set if to false
		block_adj[s.x + pos.x][s.y + pos.y] = false
	match held_block.block_info.upgrade:
		block.UpgradeType.SHIELD:
			save_mi.file_01.shields -= 1
		block.UpgradeType.POWER_BOMB:
			save_mi.file_01.power_bombs -= 1
		block.UpgradeType.OPTION:
			save_mi.file_01.options -= 1
		_:
			print("block had no upgrade type in pick up function. this is strange")
	
	if use_value:
		sfx_pi.play_effect(pick_up_sf)
	
	#remove the block from the block_dict
	
	save_mi.file_01.block_dict[pos] = "none"
	
	print_adj()
	
func put_down_main(pos : Vector2i, use_value : bool) -> void:
	#i think put down main needs to have all of the grid space checking things inside it.
	#i dont want that in the signal thing. thatd be cluttered as fuck
	#use value indicates whether to affect the upgrade amount. false for just putting blocks down on ready
	
	for p  in held_block.block_info.grid_shape:
		#compare each spots position in relation to the position of placement to the grid.
		#also check for in bounds
		
		#combined position of this element
		var new_pos : Vector2 = pos + p
		
		#in case part of the block is outside the thing
		if new_pos.x > 3 || new_pos.y > 5 || new_pos.x < 0 || new_pos.y < 0:
			print("aborted place oob")
			print(new_pos)
			return 
		
		#in case it overlaps with another block
		if block_adj[new_pos.x][new_pos.y]:
			print("aborted place block collision: ", new_pos)
			return
		

		
	#made it through for, all spots should be free
	for p  in held_block.block_info.grid_shape:
		#compare each spots position in relation to the position of placement to the grid.
		#also check for in bounds
		
		#combined position of this element
		var new_pos : Vector2 = pos + p
		
		#mark each spot as taken
		block_adj[new_pos.x][new_pos.y] = true
	
	if use_value:
		sfx_pi.play_effect(put_down_sf)
		match held_block.block_info.upgrade:
			block.UpgradeType.SHIELD:
				save_mi.file_01.shields += 1
			block.UpgradeType.POWER_BOMB:
				save_mi.file_01.power_bombs += 1
			block.UpgradeType.OPTION:
				save_mi.file_01.options += 1
			_:
				print("block had no upgrade type in put down function. this is stranges")
	
	#add the block to the save file
	save_mi.file_01.block_dict[pos] = held_block.block_info.block_type
	
	
	get_tree().get_root().remove_child.call_deferred(held_block)
	block_grid.get_child(pos.x).get_child(pos.y).add_child.call_deferred(held_block)
	held_block.global_position = main_origin.global_position + (Vector2(pos.y, pos.x) * 16)
	
	held_block = null
	
	print_adj()
	
func pick_up_spare(pos : Vector2i, use_value : bool) -> void:
	#grab the block from the spare grid and yeah thats it
	#dont have to worry about upgrade save values cause its a spare
	
	if spare_grid.get_child(pos.x).get_child(pos.y).get_child_count() == 0:
		return
	
	held_block = spare_grid.get_child(pos.x).get_child(pos.y).get_child(0)
	spare_grid.get_child(pos.x).get_child(pos.y).remove_child(held_block)
	get_tree().get_root().add_child.call_deferred(held_block)
	held_block.global_position = sim_select.icon.global_position
	
	if use_value:
		sfx_pi.play_effect(pick_up_sf)
	
	#update spare count
	match held_block.block_info.upgrade:
		block.UpgradeType.SHIELD:
			save_mi.file_01.spare_dict["shield_block"] -= 1
		block.UpgradeType.POWER_BOMB:
			save_mi.file_01.spare_dict["power_block"] -= 1
		block.UpgradeType.OPTION:
			save_mi.file_01.spare_dict["laser_block"] -= 1
		_:
			print("block didnt have type?")
	
func put_down_spare(pos : Vector2i, use_value : bool) -> void:
	#just add the held thing to the relevant spare spot. reverse pick up.

	if use_value:
		match held_block.block_info.upgrade:
			block.UpgradeType.SHIELD:
				save_mi.file_01.spare_dict["shield_block"] += 1
			block.UpgradeType.POWER_BOMB:
				save_mi.file_01.spare_dict["power_block"] += 1
			block.UpgradeType.OPTION:
				save_mi.file_01.spare_dict["laser_block"] += 1
	
	if use_value:
		sfx_pi.play_effect(put_down_sf)

	#not going to have a limit of one to spot. ill just have multiple in the same spot.
	get_tree().get_root().remove_child.call_deferred(held_block)
	spare_grid.get_child(pos.x).get_child(pos.y).add_child.call_deferred(held_block)
	held_block.global_position = (top_origin.global_position + Vector2(pos*32))
	held_block = null

func print_adj() -> void:
	
	var x : int = 0
	var y : int = 0
	var o : String = ""
	
	while x < block_adj.size():
		while y < block_adj[0].size():
			o += str(block_adj[x][y])
			o += '\t'
			y += 1
		x += 1
		y = 0
		print(o)
		o = ""
	
func _on_simple_select_moved():
	if is_instance_valid(held_block):
		held_block.global_position = sim_select.icon.global_position
		
#top grid activated signal
func _on_spare_option_0_0_activated():
	if held_block == null:
		pick_up_spare(Vector2i(0,0), true)
	else:
		put_down_spare(Vector2i(0,0), true)
	
#main grid activated signals
func try_main(g_pos : Vector2i) -> void:
	if held_block != null:
		put_down_main(g_pos, true)
		print("attempted put down")
	else:
		pick_up_main(g_pos,true)
		print("attempt pick up")

func _on_option_0_0_activated():
	try_main(Vector2i(0,0))
	
func _on_option_0_1_activated():
	try_main(Vector2i(1,0))
	
func _on_option_0_2_activated():
	try_main(Vector2i(2,0))

func _on_option_0_3_activated():
	try_main(Vector2i(3,0))

func _on_option_1_0_activated():
	try_main(Vector2i(0,1))

func _on_option_1_1_activated():
	try_main(Vector2i(1,1))

func _on_option_1_2_activated():
	try_main(Vector2i(2,1))

func _on_option_1_3_activated():
	try_main(Vector2i(3,1))

func _on_option_2_0_activated():
	try_main(Vector2i(0,2))

func _on_option_2_1_activated():
	try_main(Vector2i(1,2))

func _on_option_2_2_activated():
	try_main(Vector2i(2,2))

func _on_option_2_3_activated():
	try_main(Vector2i(3,2))

func _on_option_3_0_activated():
	try_main(Vector2i(0,3))

func _on_option_3_1_activated():
	try_main(Vector2i(1,3))

func _on_option_3_2_activated():
	try_main(Vector2i(2,3))

func _on_option_3_3_activated():
	try_main(Vector2i(3,3))

func _on_option_4_0_activated():
	try_main(Vector2i(0,4))

func _on_option_4_1_activated():
	try_main(Vector2i(1,4))

func _on_option_4_2_activated():
	try_main(Vector2i(2,4))

func _on_option_4_3_activated():
	try_main(Vector2i(3,4))

func _on_left_activated():
	scene_mi.load_scene(left_scene)

func _on_right_activated():
	scene_mi.load_scene(hangar_scene)

func _on_spare_option_1_0_activated():
	if held_block == null:
		pick_up_spare(Vector2i(1,0), true)
	else:
		put_down_spare(Vector2i(1,0), true)

func _on_spare_option_2_0_activated():
	if held_block == null:
		pick_up_spare(Vector2i(2,0), true)
	else:
		put_down_spare(Vector2i(2,0), true)
