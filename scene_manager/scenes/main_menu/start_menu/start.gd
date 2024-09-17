extends Node2D
class_name start_menu


#TODO: decide where the initial scene is. straight to battle? or start in hangar? idk

@export var start_link : scene_link
@export var settings_link : scene_link

@export var prep_rhythm : music_link

#region autoloads

@onready var scene_mi : scene_manager = get_node("/root/scene_manager_auto")
@onready var app_mi : app_manager = get_node("/root/app_manager_auto")
@onready var music_pi : music_player = get_node("/root/music_player_auto")

#endregion


func _ready():
	music_pi.play_track(prep_rhythm)

func _on_start_option_activated():
	scene_mi.load_temp_to_next(start_link, 3)
	music_pi.stop_track()

func _on_settings_option_activated():
	scene_mi.load_scene(settings_link)

func _on_quit_option_activated():
	app_mi.quit_game()
