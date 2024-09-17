extends Node2D

@export var win_music : music_link 

@export var blanket_link : music_link

@export var coin_ref : PackedScene

@onready var music_pi : music_player = get_node("/root/music_player_auto")
@onready var player_li : player_loader = get_node("/root/player_loader_auto")
@onready var shmup_hi : shmup_health = get_node("/root/shmup_health_auto")
@onready var score_mi : score_manager = get_node("/root/score_manager_auto")
@onready var screen_fi : screen_fx = get_node("/root/screen_fx_auto")
@onready var save_mi : save_manager = get_node("/root/save_manager_auto")

func _ready():
	if save_mi.file_01.day < 3:
		save_mi.file_01.day = 3
	music_pi.play_track(win_music)
	player_li.unload_player()
	shmup_hi.set_visible(false)
	score_mi.set_visible(false)
	screen_fi.clear_rect()
	
func _on_blanket_timer_timeout():
	music_pi.play_track(blanket_link)
	


func _on_cointimer_timeout():
	var new_coin : Node2D = coin_ref.instantiate()
	get_tree().get_root().add_child.call_deferred(new_coin)
	new_coin.global_position = Vector2(randi_range(10,110), -5)
	
