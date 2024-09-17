extends Node2D
class_name enemy_health


#should contain max hp, hp, functions for damage, a couple of basic signals.

@export var hp : int = 1

@export var mhp : int = 1

@export var enemy_node : Node2D				#reference to the node to free on death


@export var hit_sf : sf_link				#sf for taking damage

@export var death_fx : fx_link 				#simple fx to use on death
@export var death_sf : sf_link
@export var drop_type : String = "none"

@export var score_value : int = 100
@export var use_score : bool = true

signal hit
signal dead

var dying : bool = false

#region autoloads
@onready var simple_fi : simple_fx = get_node("/root/simple_fx_auto")
@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")
@onready var simple_di : simple_drop = get_node("/root/simple_drop_auto")
@onready var score_mi : score_manager = get_node("/root/score_manager_auto")

#endregion

func damage(dam : int) -> void:
	hp -= dam
	hit.emit()
	if hit_sf != null:
		sfx_pi.play_effect(hit_sf)
	
	if hp <= 0 && !dying:
		die()
		dying = true
 	
func die() -> void:
	if death_fx:
		death_fx.pos = enemy_node.global_position
		simple_fi.place_fx(death_fx)
	if death_sf: 
		sfx_pi.play_effect(death_sf)
	if drop_type != "none":
		simple_di.drop_item(drop_type, enemy_node.global_position)
	if use_score:
		score_mi.update_score(score_value)
	
	dead.emit()
	
	enemy_node.queue_free()
	
func _on_hit_shape_area_entered(_area):
	damage(1)
	
func _on_kill_timer_timeout():
	queue_free()
