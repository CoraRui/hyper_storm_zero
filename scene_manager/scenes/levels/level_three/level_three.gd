extends Node2D

#positional + moving screen
#backup plan minimum upload
#9 hours until deadline


@export var m_frame : Node2D

@export var level_music : music_link

@export var spawn_node : Node2D

@export var ship_link : enemy_link

@export var big_boss_ref : PackedScene

@export var boss_area : Area2D

var boss : int = 0 #start boss fight at 2

var moving_frame : bool = true

#level 3
#vending machine drawing

@onready var player_li : player_loader = get_node("/root/player_loader_auto")
@onready var music_li : music_player = get_node("/root/music_player_auto")
@onready var enemy_li : enemy_loader = get_node("/root/enemy_loader_auto")
@onready var shmup_hi : shmup_health = get_node("/root/shmup_health_auto")
@onready var score_mi : score_manager = get_node("/root/score_manager_auto")


func _ready():
	player_li.load_player()
	player_li.set_spawn(spawn_node)
	music_li.play_track(level_music)
	score_mi.set_visible(true)
	shmup_hi.set_visible(true)
	
func _physics_process(_delta):
	if moving_frame:
		move_frame()

func move_frame():
	if !is_instance_valid(player_li.player_ins):
		return
	m_frame.global_position.y -= 0.5
	player_li.player_ins.global_position.y -= 0.5
	score_mi.global_position.y -= 0.5
	shmup_hi.global_position.y -= 0.5

func _on_gun_ship_area_area_entered(_area):
	boss_area.queue_free()
	var ship_ref : enemy_reference = enemy_li.find_enemy(ship_link)
	
	var ship_one : Node2D = ship_ref.enemy_ref.instantiate()
	var ship_two : Node2D = ship_ref.enemy_ref.instantiate()
	
	m_frame.add_child.call_deferred(ship_one)
	m_frame.add_child.call_deferred(ship_two)
	
	ship_one.position = Vector2i(20,-16)
	ship_two.position = Vector2i(100,-16)
	
	print("ships spawned")
	
	for c in ship_one.get_children():
		if c is enemy_health:
			c.dead.connect(ship_fight)
			print("connected")
			print(c.name)
	
	for c in ship_two.get_children():
		if c is enemy_health:
			c.dead.connect(ship_fight)
			print("connected")
			print(c.name)
	

func ship_fight():
	print("fight thing")
	boss += 1
	if boss >= 2:
		start_boss()
		
func start_boss():
	var bb_ins : big_boss = big_boss_ref.instantiate()
	get_tree().get_root().add_child.call_deferred(bb_ins)
	bb_ins.global_position = spawn_node.global_position + Vector2(-67,-144)
	moving_frame = false
	print("started boss")
	
	
	
	

