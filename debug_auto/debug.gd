extends Node2D
class_name debug

#just has some inputs for debugging various stuff. using the row num keys cause i dont use them for anything else
#also should i put the error message things here? i think so

@export var debug_active : bool = true

@export var tag_dict : Dictionary			#contains string tags and bool keys for enabling error messages.


#region autoloads

@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")
@onready var music_pi : music_player = get_node("/root/music_player_auto")
@onready var save_mi : save_manager = get_node("/root/save_manager_auto")
@onready var scene_mi : scene_manager = get_node("/root/scene_manager_auto")
@onready var player_li : player_loader = get_node("/root/player_loader_auto")

#endregion

func _input(event):
	if event.is_action_pressed("db_one"):
		save_mi.save_game()
	if event.is_action_pressed("db_two"):
		save_mi.file_01.print_file()
	if event.is_action_pressed("db_three"):
		save_mi.load_game()
	if event.is_action_pressed("db_four"):
		save_mi.file_01.block_dict[Vector2i(0,0)] = "line_shield_block"
	if event.is_action_pressed("db_five"):
		save_mi.file_01.block_dict[Vector2i(0,0)] = "line_rate_block"
	if event.is_action_pressed("db_six"):
		pass
	if event.is_action_pressed("db_seven"):
		pass
	if event.is_action_pressed("db_eight"):
		pass
	if event.is_action_pressed("db_nine"):
		pass
		
func db_print(m : String, t : String) -> void:
	#prints an error message, but only if the tag is active.
	#if the tag dict doesnt have the tag, send the error but with exclamaiton mark
	if !tag_dict.has(t):
		print("!", t, ";", m)
		return
	
	#if the tag is disabled, dont send the message.
	if tag_dict[t]:
		print(t, ": ", m)
