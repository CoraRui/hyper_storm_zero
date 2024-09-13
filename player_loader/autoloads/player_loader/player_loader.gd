extends Node2D
class_name player_loader

#loads the player in and out of the scene. not sure how this will really be much different from the scene loader.

#TODO: link everything to save file values when the player loads. so on ready


@export var player_ref : PackedScene
@export var player_ins : shmup_player

@export var option_ref : PackedScene			#reference to option gun

@onready var debug_i : debug = get_node("/root/debug_auto")

func load_player(pos : Vector2i = Vector2i(60,150)) -> void:

	if player_ins:
		debug_i.db_print("tried to spawn player when player already exists", "pla_loa")
		return

	#well for now ill just put them on the root and keep a reference to them. then have an unload function
	player_ins = player_ref.instantiate()
	get_tree().get_root().add_child(player_ins)
	player_ins.global_position = pos
	
	#TODO: link to save file values
	#instantiate option guns just do one for now.
	var new_option : option_move = option_ref.instantiate()
	get_tree().get_root().add_child.call_deferred(new_option)
	new_option.global_position = player_ins.global_position
	new_option.follow_node = player_ins
	
	
	
	
	
	
	
func unload_player():
	if is_instance_valid(player_ins):
		player_ins.queue_free()
		player_ins = null
	else:
		player_ins = null

