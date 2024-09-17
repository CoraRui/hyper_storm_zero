extends Node2D
class_name game_over_scene


@export var game_over_music : music_link

@export var esc_label : Label

@export var esc_timer : Timer

@export var esc_flash : Timer

@export var cam : Camera2D

@onready var music_pi : music_player = get_node("/root/music_player_auto")
@onready var enemy_li : enemy_loader = get_node("/root/enemy_loader_auto")
@onready var score_mi : score_manager = get_node("/root/score_manager_auto")
@onready var shmup_hi : shmup_health = get_node("/root/shmup_health_auto")


func _ready():
	music_pi.play_track(game_over_music)
	enemy_li.clear_enemies()
	score_mi.clear()
	score_mi.set_visible(false)
	cam.make_current()
	
func _on_esc_timer_timeout():
	esc_label.set_visible(true)
	esc_flash.start()
	
func _on_esc_flash_timeout():
	esc_label.set_visible(!esc_label.visible)
