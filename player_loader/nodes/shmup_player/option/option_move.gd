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

var move_arr : Array[Vector2]
var end_index : int = 0
@export var move_arr_size : int = 40			# how many positions before the option starts to move
var start_index : int = 1

@onready var save_mi : save_manager = get_node("/root/save_manager_auto")


func _ready():
	match save_mi.file_01.speed_up:
		0:
			move_arr_size = 40
		1:
			move_arr_size = 30
		2:
			move_arr_size = 20
		3:
			move_arr_size = 10
	
	for i in move_arr_size:
		move_arr.append(follow_node.global_position)
	move_arr.fill(follow_node.global_position)
	

func _physics_process(_delta):
	if is_instance_valid(follow_node):
		move_trail()
	else:
		queue_free()
		return
func move():
	#calculate which quadrant the follow node is in, solve for a dir8 to use to move, then translate in that direction.
	
	if(!is_instance_valid(follow_node)):
		queue_free()
		return
	
	var mvec : Vector2i = Dir.dir8_to_uvec(Dir.dir8_to_point(global_position, follow_node.global_position)) * Vector2i(1,-1)
	
	#only move towards if the distance between the two is too long
	if global_position.distance_to(follow_node.global_position) > 16:
		global_position += Vector2(mvec)

func move_trail():
	#record the positions of the follow node in an array. whenever there is a new value, record it to the array.
	#when the array reaches a certain length, move to the value at the index
	if !is_instance_valid(follow_node):
		return
	var pend : int = end_index - 1
	if pend < 0:
		pend = move_arr_size - 1
	
	if follow_node.global_position != move_arr[pend]:
		global_position = move_arr[start_index]
		move_arr[end_index] = follow_node.global_position
		end_index += 1
		if end_index >= move_arr_size:
			end_index = 0
		start_index += 1
		if start_index >= move_arr_size:
			start_index = 0
	
