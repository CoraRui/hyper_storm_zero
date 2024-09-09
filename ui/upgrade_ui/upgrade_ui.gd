extends Node2D
class_name upgrade_ui

#this class should take input from the upgrade ui and use it to update the save file with the players choices
#if they select a certain upgrade, it should deduct their money and apply that upgrade to the file, hence the next run.
#etc etc.


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


@onready var save_mi : save_manager = get_node("/root/save_manager_auto")
@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")

func _ready():
	pass

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

func _on_fire_rate_option_activated():
	if save_mi.file_01.coins >= 5 && save_mi.file_01.money_up < 3:
		sfx_pi.play_effect(money_sf)
		save_mi.file_01.coins -= 5
		save_mi.file_01.money_up += 1
		money_tier.play(str(save_mi.file_01.money_up))

func _on_option_three_activated():
	if save_mi.file_01.coins >= 5 && save_mi.file_01.rate_up < 3:
		sfx_pi.play_effect(fire_rate_sf)
		save_mi.file_01.coins -= 5
		save_mi.file_01.rate_up += 1
		rate_tier.play(str(save_mi.file_01.rate_up))











