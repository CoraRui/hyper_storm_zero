extends Node2D
class_name title_scene


@export var start_link : scene_link

@export var start_label : Label

@export var start_sf : sf_link

@export var mus_link : music_link


@onready var scene_mi : scene_manager = get_node("/root/scene_manager_auto")

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("action"):
		scene_mi.load_scene(start_link)
		
func _on_start_flash_timeout():
	start_label.set_visible(!start_label.visible)
