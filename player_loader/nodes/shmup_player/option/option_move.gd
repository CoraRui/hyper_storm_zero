extends Node2D
class_name option_move



#TODO: im thinking of a whole new way to do this which would just be to record an array of all of the values that the ship was previously on, and have the 
#option follow that list. it would be pretty jank/inefficient but it would work.
#i think its pretty much working the way it is so i might not fuck with it. but if i get the chance ill make it follow a trail instead of actually actively
#direcitonally following

#moves the option towards the specified point, maybe only while its moving? or just while its a certain distance away.
#probably move 8 directionally, judging by what "quadrant" the follow_node is in

@export var follow_node : Node2D
@export var move_target : Node2D

func _physics_process(_delta):
	move()

func move():
	#calculate which quadrant the follow node is in, solve for a dir8 to use to move, then translate in that direction.
	
	if(!is_instance_valid(follow_node)):
		queue_free()
		return
	
	var mvec : Vector2i = Dir.dir8_to_uvec(Dir.dir8_to_point(global_position, follow_node.global_position)) * Vector2i(1,-1)
	
	#only move towards if the distance between the two is too long
	if global_position.distance_to(follow_node.global_position) > 16:
		global_position += Vector2(mvec)
