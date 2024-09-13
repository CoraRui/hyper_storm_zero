extends Node2D
class_name level_two


#level two!
@export var clear_label : Label
@export var next_stage_timer : Timer
@export var upgrade_scene : scene_link 

@onready var scene_mi : scene_manager = get_node("/root/scene_manager_auto")
@onready var player_li : player_loader = get_node("/root/player_loader_auto")
@onready var enemy_li : enemy_loader = get_node("/root/enemy_loader_auto")
@onready var shmup_hi : shmup_health = get_node("/root/shmup_health_auto")

func _ready():
	player_li.load_player()
	
func level_clear() -> void:
	clear_label.set_visible(true)
	next_stage_timer.start()
	enemy_li.clear_enemies()
	shmup_hi.set_visible(false)


func _on_next_stage_timeout():
	scene_mi.load_scene(upgrade_scene)
