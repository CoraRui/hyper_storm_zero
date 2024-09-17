extends Node2D
class_name big_boss

#has a big ass eye, spawns in energy beams,  has little dudes raining from the top.
#only colored sprite in the game is the health bar and the eye maybe


@export var progress_bar : ProgressBar 

@export var next_timer : Timer

@export var laser_timer : Timer
@export var blast_ref : PackedScene

@export var win_scene : scene_link

@export var boss_anim : AnimatedSprite2D

@export var kill_timer : Timer

@export var bub_ref : PackedScene
@export var dial_ref : PackedScene

@export var planet_death_sf : sf_link

var no_fucking_laser : bool = false

#region autoloads
@onready var player_li : player_loader = get_node("/root/player_loader_auto")
@onready var scene_mi : scene_manager = get_node("/root/scene_manager_auto")
@onready var music_pi : music_player = get_node("/root/music_player_auto")
@onready var screen_fi : screen_fx = get_node("/root/screen_fx_auto")
@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")
#endregion

func _ready():
	player_li.load_player()

	#next_timer.start()

func laser_fire() -> void:
	if !is_instance_valid(player_li.player_ins) || no_fucking_laser:
		return
	var new_blast : Node2D = blast_ref.instantiate()
	get_tree().get_root().add_child.call_deferred(new_blast)
	new_blast.global_position = player_li.player_ins.global_position + Vector2(0, -60)
	
func _on_enemy_health_hit():
	progress_bar.value -= 1

func _on_enemy_health_dead():
	no_fucking_laser = true
	next_timer.start()
	music_pi.stop_track()
	screen_fi.fade_to_white(3)
	kill_timer.start()
	sfx_pi.play_effect(planet_death_sf, true)
	
func _on_next_scene_timeout():
	scene_mi.load_scene(win_scene)
	
func _on_laser_timer_timeout():
	laser_fire()


func _on_kill_timer_timeout():
	boss_anim.queue_free()

func _on_bub_timer_timeout():
	if !is_instance_valid(player_li.player_ins):
		return
	var new_bub : Node2D = bub_ref.instantiate()
	get_tree().get_root().add_child.call_deferred(new_bub)
	new_bub.global_position = Vector2(randi_range(10,115),player_li.player_ins.global_position.y - 100)
	
func _on_dial_timer_timeout():
	if !is_instance_valid(player_li.player_ins):
		return
	var new_dial : Node2D = dial_ref.instantiate()
	get_tree().get_root().add_child.call_deferred(new_dial)
	new_dial.global_position = Vector2(randi_range(10,115),player_li.player_ins.global_position.y - 100)
