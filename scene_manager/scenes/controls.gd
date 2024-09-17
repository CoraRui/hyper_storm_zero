extends Node2D
class_name controls_page


@export var return_label : Label

@export var start_link : scene_link

@onready var scene_mi : scene_manager = get_node("/root/scene_manager_auto")

func _input(event):
	if(event.is_action_pressed("action_2")):
		scene_mi.load_scene(start_link)

func _on_return_timer_timeout():
	return_label.set_visible(!return_label.visible)
