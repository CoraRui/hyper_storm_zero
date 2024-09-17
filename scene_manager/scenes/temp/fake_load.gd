extends Node2D
class_name fake_load

@export var next_timer : Timer

@export var next_scene : scene_link

@export var next_label : Label

@onready var scene_mi : scene_manager = get_node("/root/scene_manager_auto")

func _on_next_timer_timeout():
	scene_mi.load_scene(next_scene)


func _on_flash_timer_timeout():
	next_label.set_visible(!next_label.visible)
