extends Node2D
class_name level_one

@onready var player_li : player_loader = get_node("/root/player_loader_auto")
@onready var shmup_hi : shmup_health = get_node("/root/shmup_health_auto")

func _ready():
	player_li.load_player()
	shmup_hi.set_visible(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
