extends Node2D
class_name shmup_health

#health script for the player in a shmup
#i essentially just want the player to lose a life and respawn with a temp shield when they get hit.
#i can contain that within this script i think. but what about when out of lives?
#ill defer that thought, but ill make a game over autoload to handle that.
#in general for the game though, i think for now itll be a one run thing. you lose, game over, reset.
#ideally therell be a more comprehensive system. but might not be able to do that

#made this an autoload cause it essentially has to load the player in and out.
#i guess it could be a part of the player loader, but if i wanted to do a game thats not a shmup, that wouldnt 
#be easily separable

#anyways, the player should use the health autoload when it gets hit.



@export var hurt_sf : sf_link
@export var death_sf : sf_link
@export var death_fx : fx_link

@export var respawn_location : Vector2i

@export var destroy_timer : Timer
@export var respawn_timer : Timer

@export var life_arr : Array[AnimatedSprite2D]

@export var game_over_link : scene_link

@onready var save_mi : save_manager = get_node("/root/save_manager_auto")
@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")
@onready var player_li : player_loader = get_node("/root/player_loader_auto")
@onready var simple_fi : simple_fx = get_node("/root/simple_fx_auto")
@onready var scene_li : scene_manager = get_node("/root/scene_manager_auto")


func _ready():
	var i : int = life_arr.size() - 1
	while i  >= save_mi.file_01.lives:
		life_arr[i].set_visible(false)
		i -= 1
		
func hit():
	player_li.player_ins.freeze(true)
	destroy_timer.start()
	
func _on_destroy_timer_timeout():
	sfx_pi.play_effect(death_sf)
	simple_fi.place_fx(death_fx)
	respawn_timer.start()
	player_li.unload_player()
	
func _on_respawn_timer_timeout():
	print("current life", save_mi.file_01.lives)
	life_arr[save_mi.file_01.lives-1].set_visible(false)
	if save_mi.file_01.lives > 0:
		player_li.load_player()
		save_mi.file_01.lives -= 1
		
	else:
		scene_li.load_scene(game_over_link)
