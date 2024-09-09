extends Node2D
class_name coin

#should add a certain amount to the players money

@export var value : int = 5

@export var pickup_sf : sf_link

@onready var save_mi : save_manager = get_node("/root/save_manager_auto")
@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")


func _on_clear_timer_timeout():
	queue_free()


func _on_coin_area_area_entered(area):
	save_mi.file_01.coins += value;
	save_mi.file_01.print_file()
	sfx_pi.play_effect(pickup_sf)
	queue_free()
	
