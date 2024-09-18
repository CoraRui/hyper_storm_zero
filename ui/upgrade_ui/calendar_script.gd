extends Node2D
class_name calendar_node

#just handles loading of specific "days"

#TODO: show which days are cleared and which day is next based on save file and load next day on activate
#TODO: reassign simple select references, directional, icon points, etcetc

#so ill just have the options signals go here, i guess ill have this script decide which days the player can navigate to.

@export var option_arr : Array[option]		#references to the options for each day to connect them adjacently depending on save 
											#file day
@export var finish_arr : Array[Node2D]

#region level_scene_links
@export_group("main days")
@export var day_one_link : scene_link
@export var day_two_link : scene_link
@export var day_three_link : scene_link
@export var day_four_link : scene_link
@export_group("","")

@export_group("test days")
@export var test_one_link : scene_link
@export var test_two_link : scene_link
@export var test_three_link : scene_link
@export var test_four_link : scene_link
@export_group("","")

#endregion

#region autoloads

@onready var save_mi : save_manager = get_node("/root/save_manager_auto")
@onready var scene_mi : scene_manager = get_node("/root/scene_manager_auto")
@onready var music_pi : music_player = get_node("/root/music_player_auto")

#endregion

func _ready():
	initialize_dates()
	
func initialize_dates():
	if save_mi.file_01.day > 0:
		finish_arr[0].set_visible(true)
		option_arr[0].right_option = option_arr[1]
		option_arr[1].left_option = option_arr[0]
	if save_mi.file_01.day > 1:
		finish_arr[1].set_visible(true)
		option_arr[1].right_option = option_arr[2]
		option_arr[2].left_option = option_arr[1]
	if save_mi.file_01.day > 2:
		finish_arr[2].set_visible(true)
		option_arr[2].right_option = option_arr[3]
		option_arr[3].left_option = option_arr[2]
	if save_mi.file_01.day > 3:
		finish_arr[3].set_visible(true)
	
#region four day signals

func _on_day_one_4_activated():
	scene_mi.load_temp_to_next(day_four_link, 4)
	music_pi.stop_track()

func _on_day_one_3_activated():
	scene_mi.load_temp_to_next(day_three_link, 4)
	music_pi.stop_track()

func _on_day_one_2_activated():
	scene_mi.load_temp_to_next(day_two_link, 4)
	music_pi.stop_track()

func _on_day_one_activated():
	scene_mi.load_temp_to_next(day_one_link, 4)
	music_pi.stop_track()

#endregion

#region test_level signals

func _on_test_one_activated():
	scene_mi.load_temp_to_next(test_one_link, 2)
	music_pi.stop_track()

func _on_test_two_activated():
	scene_mi.load_temp_to_next(test_two_link, 2)
	music_pi.stop_track()

func _on_test_three_activated():
	scene_mi.load_temp_to_next(test_three_link, 2)
	music_pi.stop_track()

func _on_test_four_activated():
	scene_mi.load_temp_to_next(test_four_link, 2)
	music_pi.stop_track()

#endregion

