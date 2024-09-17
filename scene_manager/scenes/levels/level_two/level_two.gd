extends Node2D
class_name level_two


#level two!
@export var clear_label : Label
@export var next_stage_timer : Timer
@export var upgrade_scene : scene_link 

@export var level_music : music_link
@export var clear_music : music_link

var ship_one : Node2D
var ship_two : Node2D
var boss : bool = false

@onready var scene_mi : scene_manager = get_node("/root/scene_manager_auto")
@onready var player_li : player_loader = get_node("/root/player_loader_auto")
@onready var enemy_li : enemy_loader = get_node("/root/enemy_loader_auto")
@onready var shmup_hi : shmup_health = get_node("/root/shmup_health_auto")
@onready var music_pi : music_player = get_node("/root/music_player_auto")
@onready var score_mi : score_manager = get_node("/root/score_manager_auto")
@onready var save_mi : save_manager = get_node("/root/save_manager_auto")

func _ready():
	enemy_li.queue_finish.connect(boss_time)
	player_li.load_player()
	shmup_hi.set_visible(true)
	score_mi.set_visible(true)
	music_pi.play_track(level_music)
	
func _physics_process(_delta):
	if boss && !ship_one && !ship_two:
		level_clear()
		boss = false
	
func level_clear() -> void:
	print("level cleared timer started")
	clear_label.set_visible(true)
	next_stage_timer.start()
	enemy_li.clear_enemies()
	shmup_hi.set_visible(false)
	music_pi.play_track(clear_music)
	score_mi.clear()
	score_mi.set_visible(false)
	if save_mi.file_01.day < 2:
		save_mi.file_01.day = 2
		save_mi.save_game()
		

	
func boss_time():
	#spawn two gunships, advance to next level when theyre defeated.
	var link : enemy_link = enemy_link.new()
	link.enemy_name = "gun_ship"
	ship_one = enemy_li.find_enemy(link).enemy_ref.instantiate()
	get_tree().get_root().add_child.call_deferred(ship_one)
	ship_two = enemy_li.find_enemy(link).enemy_ref.instantiate()
	get_tree().get_root().add_child.call_deferred(ship_two)
	ship_one.global_position = Vector2i(20, -16)
	ship_two.global_position = Vector2i(90, -16)
	boss = true

	
func _on_next_stage_timeout():
	player_li.unload_player()
	scene_mi.load_scene(upgrade_scene)
