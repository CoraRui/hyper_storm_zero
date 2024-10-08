extends Node2D
class_name scene_manager

#basic loading in and out of scenes to the root node. or to this node idk.
#can reload duplicates. cause idk why not

#TODO: load transitions in scene link, delays, sfx, etc.
#TODO: add some transition from the start screen to whatever gameplay.



@export var current_scene : Node2D

@export var scene_arr : Array[scene]

@export var fail_scene : scene

@export var temp_scene : scene_link

@onready var debug_i : debug = get_node("/root/debug_auto")

func load_scene(sl : scene_link):
	
	var new_scene : scene = find_scene(sl)
	
	if current_scene:
		current_scene.queue_free()
	
	current_scene = new_scene.scene_ref.instantiate()
	
	get_tree().get_root().add_child.call_deferred(current_scene)

func find_scene(sl : scene_link) -> scene:
	for s in scene_arr:
		if s.scene_name == sl.scene_name:
			return s
			
	return fail_scene
	
func load_temp_to_next(sl : scene_link, d : float) -> void:
	#just loads in the temp scene and directs the temp to the actual desired next
	load_scene(temp_scene)
	current_scene.next_scene = sl
	current_scene.next_timer.wait_time = d

