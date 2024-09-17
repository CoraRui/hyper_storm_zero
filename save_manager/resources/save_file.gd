extends Resource
class_name save_file

#contains info for the main save file

#need a way to keep track of upgrade blocks. probably just like. an array of PackedScene block_nodes?
#pretty sure thats the only easy way to do it. yup. well... it'll still be a cyclical reference right?
#i hate to say it but i think i need some sort of block manager thing... cause then it could just be string refs
#in the file and the grid ui could load from that.... whatever it wont take long.

#TODO: what should the initial save file be and how should the save_file change based on quits?
#TODO: when to save file?
#TODO: add spare block info to save load functions


@export var player_name : String = "player"		#name of person playing game
@export var coins : int = 10					#current health idk whatever
@export var day : int = 0					#current progress in days, should be updated on level clear.
@export var lives : int = 2					#lives left
@export var score_one : int			#holds scores for each day
@export var score_two : int = 0			#holds scores for each day
@export var score_three : int = 0			#holds scores for each day
@export var score_four : int = 0			#holds scores for each day


@export_group("upgrades")
@export var speed_up : int = 0
@export var rate_up : int = 0
@export var money_up : int = 0
#these upgrades are whether the upgrade is actually active. meaning that they are increased when a block is placed in the grid
@export var options : int = 0				#how many options, secondary bullet guns
@export var shields : int = 0				#how many extra shields? thinking an extra hit per life, maybe regen
@export var power_bombs : int = 0

#vector position keys, string values of whats on the grid
#"laser_block", "power_block", "shield_block"
@export var block_dict : Dictionary = {
}
#contains which blocks the player has in storage. string key, int values string is also the name of the block in block loader.
# has "laser_block", "power_block", and "shield_block"
@export var spare_dict : Dictionary = {
	"shield_block" : 0,
	"power_block" : 0,
	"laser_block" : 0,
}
@export_group("","")

#region settings values

@export_group("settings")
@export var master_volume : int = 5
@export var music_volume : int = 5
@export var sfx_volume : int = 5
@export_group("","")

#endregion

@export var dog_statue : int = 0

#converts this file to a dictionary
func this_to_dict() -> Dictionary:
	#converts this save_file into dictionary format
	var new_dict : Dictionary = {
		"player_name" : player_name,
		"coins" : coins,
		"day" : day,
		"lives" : lives,
		"speed_up" : speed_up,
		"rate_up" : rate_up,
		"money_up" : money_up,
		"options" : options,
		"shields" : shields,
		"power_bombs" : power_bombs,
		"block_dict" : block_dict,
		"spare_dict" : spare_dict,
		"master_volume" : master_volume,
		"music_volume" : music_volume,
		"sfx_volume" : sfx_volume,
		"dog_statue" : dog_statue,
	}
	
	return new_dict

#static file conversions
static func dict_to_file(sd : Dictionary) -> save_file:
	#this function doesnt do anything with the current save file, its just a static overall function
	var new_file : save_file = save_file.new()
	
	new_file.player_name = sd["player_name"]
	new_file.coins = sd["coins"]
	new_file.day = sd["day"]
	new_file.lives = sd["lives"]
	new_file.speed_up = sd["speed_up"]
	new_file.rate_up = sd["rate_up"]
	new_file.money_up = sd["money_up"]
	new_file.options = sd["options"]
	new_file.shields = sd["shields"]
	new_file.power_bombs = sd["power_bombs"]
	#if i leave that in grid tries to load it and vomits
	#new_file.block_dict = sd["block_dict"]
	new_file.spare_dict = sd["spare_dict"]
	new_file.master_volume = sd["master_volume"]
	new_file.music_volume = sd["music_volume"]
	new_file.sfx_volume = sd["sfx_volume"]
	new_file.dog_statue = sd["dog_statue"]
	
	for k in sd["block_dict"].keys():
		#convert key to vector
		var k_vec : Vector2i = var_to_string.str_to_vector2i(k)
		#make new value in the dict with the new key
		new_file.block_dict[k_vec] = sd["block_dict"][k]
		
	
	return new_file
	
static func file_to_dict(sf : save_file) -> Dictionary:
	var new_dict : Dictionary = {
		"player_name" : sf.player_name,
		"coins" : sf.coins,
		"day" : sf.day,
		"lives" : sf.lives,
		"speed_up" : sf.speed_up,
		"rate_up" : sf.rate_up,
		"money_up" : sf.money_up,
		"options" : sf.options,
		"shields" : sf.shields,
		"power_bombs" : sf.power_bombs,
		"block_dict" : sf.block_dict,
		"test_vec" : sf.test_vec,
		"master_volume" : sf.master_volume,
		"music_volume" : sf.music_volume,
		"sfx_volume" : sf.sfx_volume,
	}

	
	return new_dict

func print_file() -> void:
	var sd : Dictionary = this_to_dict()
	print("")
	print("printing save file...")
	
	for k in sd.keys():
		print(k," : ", sd[k])
	
	
