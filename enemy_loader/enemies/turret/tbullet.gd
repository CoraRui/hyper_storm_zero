extends Node2D
class_name tbullet

#goes towards player

@onready var player_li : player_loader = get_node("/root/player_loader_auto")


var fuck : bool = false

func _physics_process(_delta):
	move()

func move():
	if !is_instance_valid(player_li.player_ins):
		return
	if fuck:
		global_position = global_position.move_toward(player_li.player_ins.global_position, 1)
		fuck = false
	else:
		fuck = true

func _on_exp_timer_timeout():
	queue_free()
