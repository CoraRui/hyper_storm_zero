extends Node2D
class_name upgrade_ui

#this class should take input from the upgrade ui and use it to update the save file with the players choices
#if they select a certain upgrade, it should deduct their money and apply that upgrade to the file, hence the next run.
#etc etc.


#TODO: load upgrade status from the save file

@export var money_label : Label
@export var money_anim : AnimatedSprite2D


@export var speed_tier : AnimatedSprite2D
@export var money_tier : AnimatedSprite2D
@export var rate_tier : AnimatedSprite2D



@export_group("sound effects")
@export var velocity_sf : sf_link
@export var fire_rate_sf : sf_link
@export var money_sf : sf_link
@export var spend_money_sf : sf_link
@export_group("","")

@export var grid_scene : scene_link
@export var calendar_link : scene_link		#might not need this if i just make it a group
@export var shop_link : scene_link			#maybe no need if group??? idk

@export var hangar_tutorial_label : Label
@export var calendar_tutorial_label : Label

@export var upgrade_music : music_link


@onready var save_mi : save_manager = get_node("/root/save_manager_auto")
@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")
@onready var scene_mi : scene_manager = get_node("/root/scene_manager_auto")
@onready var music_pi : music_player = get_node("/root/music_player_auto")

func _ready():
	initialize_ui()
	music_pi.play_track(upgrade_music)
	
func update_money() -> void:
	money_label.text = str(save_mi.file_01.coins) + "G"
	
	
func initialize_ui() -> void:
	update_money()
	speed_tier.play(str(save_mi.file_01.speed_up))
	rate_tier.play(str(save_mi.file_01.rate_up))
	money_tier.play(str(save_mi.file_01.money_up))
	
	#make tutorial labels visible only on the first day
	if save_mi.file_01.day == 0:
		hangar_tutorial_label.set_visible(true)
		calendar_tutorial_label.set_visible(true)
	

func update_ui() -> void:
	#grab all values from save file to write to the ui
	money_label.text = str(save_mi.file_01.coins)
	
	#tier label
	speed_tier.play(str(save_mi.file_01.speed_up))
	money_tier.play(str(save_mi.file_01.money_up))
	rate_tier.play(str(save_mi.file_01.rate_up))
	

func _on_velocity_option_activated():
	if save_mi.file_01.coins >= 5 && save_mi.file_01.speed_up < 3:
		sfx_pi.play_effect(velocity_sf)
		save_mi.file_01.coins -= 5
		save_mi.file_01.speed_up += 1
		speed_tier.play(str(save_mi.file_01.speed_up))
		update_money()
		print("velocity activated")

func _on_fire_rate_option_activated():
	if save_mi.file_01.coins >= 5 && save_mi.file_01.money_up < 3:
		sfx_pi.play_effect(money_sf)
		save_mi.file_01.coins -= 5
		save_mi.file_01.money_up += 1
		money_tier.play(str(save_mi.file_01.money_up))
		update_money()

func _on_option_three_activated():
	if save_mi.file_01.coins >= 5 && save_mi.file_01.rate_up < 3:
		sfx_pi.play_effect(fire_rate_sf)
		save_mi.file_01.coins -= 5
		save_mi.file_01.rate_up += 1
		rate_tier.play(str(save_mi.file_01.rate_up))
		update_money()

#transfer to the grid ui
func _on_left_option_activated():
	scene_mi.load_scene(grid_scene)
	
func _on_right_option_activated():
	#probably calendar
	pass # Replace with function body.
