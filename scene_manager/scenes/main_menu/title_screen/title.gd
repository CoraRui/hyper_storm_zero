extends Node2D
class_name title_scene


@export var start_link : scene_link

@export var start_label : Label

@export var start_sf : sf_link

@export var title_music : music_link

@onready var scene_mi : scene_manager = get_node("/root/scene_manager_auto")
@onready var music_pi : music_player = get_node("/root/music_player_auto")

func _ready():
	music_pi.play_track(title_music)

func _input(event):
	if event.is_action_pressed("action"):
		scene_mi.load_scene(start_link)
	if Input.is_anything_pressed():
		scene_mi.load_scene(start_link)
		
func _on_start_flash_timeout():
	start_label.set_visible(!start_label.visible)
