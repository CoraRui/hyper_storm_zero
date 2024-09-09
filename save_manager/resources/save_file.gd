extends Resource
class_name save_file

#contains info for the main save file

@export var player_name : String = "cora"		#name of person playing game
@export var coins : int = 0					#current health idk whatever
@export var day : int = 0
@export var lives : int = 2					#lives left


@export_group("upgrades")
@export var speed_up : int = 0
@export var rate_up : int = 0
@export var money_up : int = 0
@export_group("","")

#region settings values

@export_group("settings")
@export var master_volume : int = 5
@export var music_volume : int = 5
@export var sfx_volume : int = 5
@export_group("","")

#endregion

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
		"master_volume" : master_volume,
		"music_volume" : music_volume,
		"sfx_volume" : sfx_volume,
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
	new_file.master_volume = sd["master_volume"]
	new_file.music_volume = sd["music_volume"]
	new_file.sfx_volume = sd["sfx_volume"]
	
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
		"master_volume" : sf.master_volume,
		"music_volume" : sf.music_volume,
		"sfx_volume" : sf.sfx_volume,
	}
	
	return new_dict

func print_file() -> void:
	var sd : Dictionary = this_to_dict()
	
	for k in sd.keys():
		print(k," : ", sd[k])
	
	
