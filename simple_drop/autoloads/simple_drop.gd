extends Node2D
class_name simple_drop

#autoload that handles item drops. probably not going to do a whole link as its literall just going to place a node
#in a spot. i could honestly probably just use enemy loader but clutter, so nah.


@export var drop_arr : Array[drop_ref]

@export var fail_drop : drop_ref



func drop_item(n : String, p : Vector2i):
	var new_drop : Node2D = find_drop(n).drop_scene.instantiate()
	get_tree().get_root().add_child.call_deferred(new_drop)
	new_drop.global_position = p
	

func find_drop(n : String) -> drop_ref:
	#finds a drop by string. not doing a drop link cause i really dont think its that much.
	for d in drop_arr:
		if d.drop_name == n:
			return d
	
	return fail_drop




