extends Node2D
class_name enemy_health


#should contain max hp, hp, functions for damage, a couple of basic signals.
#TODO: finalize so i can make it local, or find a way to change shape size without localizing

@export var hp : int = 1

@export var mhp : int = 1

@export var enemy_node : Node2D				#reference to the node to free on death

#TODO: add default sound and anim effects for enemy health

@export var hit_sf : sf_link				#sf for taking damage

@export var death_fx : fx_link 				#simple fx to use on death
@export var death_sf : sf_link
@export var drop_type : String = "none"

signal dead

@onready var simple_fi : simple_fx = get_node("/root/simple_fx_auto")
@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")
@onready var simple_di : simple_drop = get_node("/root/simple_drop_auto")


func damage(dam : int):
	hp -= dam
	
	if hit_sf != null:
		sfx_pi.play_effect(hit_sf)
	
	if hp <= 0:
		die()
 
func die():
	
	if death_fx:
		death_fx.pos = enemy_node.global_position
		simple_fi.place_fx(death_fx)
	if death_sf: 
		sfx_pi.play_effect(death_sf)
	if drop_type != "none":
		simple_di.drop_item(drop_type, enemy_node.global_position)
	
	enemy_node.queue_free()


func _on_hit_shape_area_entered(area):
	#TODO: have some sort of reference to how much damage the player should be doing. save file?
	damage(1)
