extends Node2D
class_name level_one

@export var clear_label : Label
@export var next_stage_timer : Timer

@export var next_scene : scene_link

@export var level_music : music_link
@export var clear_music : music_link

var level_is_clear : bool = false

#region autoloads

@onready var player_li : player_loader = get_node("/root/player_loader_auto")
@onready var shmup_hi : shmup_health = get_node("/root/shmup_health_auto")
@onready var scene_mi : scene_manager = get_node("/root/scene_manager_auto")
@onready var enemy_li : enemy_loader = get_node("/root/enemy_loader_auto")
@onready var save_mi : save_manager = get_node("/root/save_manager_auto")
@onready var score_mi : score_manager = get_node("/root/score_manager_auto")
@onready var music_pi : music_player = get_node("/root/music_player_auto")

#endregion

func _ready():
	player_li.load_player()
	shmup_hi.set_visible(true)
	enemy_li.queue_finish.connect(level_clear)
	score_mi.set_visible(true)
	music_pi.play_track(level_music)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(event):
	if event.is_action_pressed("db_eight"):
		level_clear()

func level_clear() -> void:
	clear_label.set_visible(true)
	next_stage_timer.start()
	if save_mi.file_01.day < 1:
		save_mi.file_01.day = 1
		save_mi.save_game()
	music_pi.play_track(clear_music)
	level_is_clear = true
	
func _on_next_stage_timeout():
	scene_mi.load_scene(next_scene)
	player_li.unload_player()
	enemy_li.clear_enemies()
	shmup_hi.set_visible(false)
	score_mi.set_visible(false)
	save_mi.file_01.score_one = score_mi.score
	score_mi.clear()
	


func _on_flash_timer_timeout():
	if level_is_clear:
		clear_label.set_visible(!clear_label.visible)
