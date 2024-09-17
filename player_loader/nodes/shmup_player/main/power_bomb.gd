extends Node2D
class_name power_bomb

#TODO: make the entire thing. should just wipe all the enemies on the screen and play some sort of effect

#blows up all the enemies on the screen


@export var bomb_count : int = 0			#current amount of bombs the player has

@export var boom_sf : sf_link

@onready var player_li : player_loader = get_node("/root/player_loader_auto")
@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")
@onready var enemy_li : enemy_loader = get_node("/root/enemy_loader_auto")
@onready var screen_fi : screen_fx = get_node("/root/screen_fx_auto")

func _input(event):
	if event.is_action_pressed("action") && bomb_count > 0:
		bomb()

func bomb() -> void:
	enemy_li.clear_enemies()
	sfx_pi.play_effect(boom_sf)
	bomb_count -= 1
