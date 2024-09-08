extends Node2D
class_name game_over_scene


@export var game_over_music : music_link

@export var esc_label : Label

@export var esc_timer : Timer

@export var esc_flash : Timer

@onready var music_pi : music_player = get_node("/root/music_player_auto")
@onready var enemy_li : enemy_loader = get_node("/root/enemy_loader_auto")


func _ready():
	music_pi.play_track(game_over_music)
	enemy_li.clear_enemies()
	


func _on_esc_timer_timeout():
	esc_label.set_visible(true)
	esc_flash.start()


func _on_esc_flash_timeout():
	esc_label.set_visible(!esc_label.visible)
