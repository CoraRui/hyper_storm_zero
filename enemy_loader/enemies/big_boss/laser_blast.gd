extends Node2D
class_name laser_blast


@export var col_anim : AnimatedSprite2D
@export var top_anim : AnimatedSprite2D

@export var exp_timer : Timer

@export var hit_area : Area2D

@export var charge_sf : sf_link
@export var blast_sf : sf_link


#region autoloads
@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")
#endregion

func _ready():
	sfx_pi.play_effect(charge_sf)

func _on_to_blast_timeout():
	top_anim.play("default")
	#hit_area.monitorable = true
	hit_area.get_child(0).disabled = false
	sfx_pi.play_effect(blast_sf)
	exp_timer.start()


func _on_exp_timer_timeout():
	queue_free()
