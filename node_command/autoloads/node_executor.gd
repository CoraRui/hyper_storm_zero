extends Node2D
class_name node_executor


#has a list of node children. each next_command, it gets the initial child, performs its command and removes it. then it does the next one.

@export var delay_timer : Timer

@export var ready_start : bool = false

func _ready():
	do_next()

func do_next():
	#children are the commands. so get the child, perform the command, then free/remove the child, unless you need it for some reason
	var keep_going : bool = true
	var free_this : bool = true
	
	if get_child(0).name == "end_node":
		#this node
		print("hit end node")
		return
	
	if get_child(0).get_child_count() == 0:
		print("node_command: ", get_child(0).name, " has no children, so no command")
		return
	
	if !(get_child(0) is node_command):
		print("node_executor had a child that wasnt node_command. this is concerning.")
		return
	
	var comm : node_command = get_child(0)
	
	if comm.get_command() is print_comm:
		print(comm.get_command().print_string)
	elif comm.get_command() is delay_time_comm:
		delay_timer.wait_time = comm.get_command()
		delay_timer.start()
		keep_going = false
		
	#removes the finished command from the array. i dont imagin this needs to be conditional but i can always change it.
	#might be cases. who cares ill just leave it lol
	if free_this:
		remove_child(get_child(0))
		comm.queue_free()
	
	#this function runs recursively unless another funtion returns before it, or updates the keep_going bool.
	#return works unless theres still a case where theres more code to run after that commands. frinstance after a command finishes running and it still needs to
	#free the current command.
	if keep_going:
		do_next()
	
func take_commands(ns : PackedScene):
	#takes a packedscene, then adds the children of the instantiated node into its own children.
	var new_node = ns.instantiate()
	
	var new_comms : node_comm_set
	
	if !(new_node is node_comm_set):
		print("take_commands in node_executor was passed a packed scene that isnt a node command ")
		return
	else:
		new_comms = new_node
		
	var i : int = 0
	#get the index of the end node. just use i to store the index of the node preceding the end node 
	while get_child(i+1).name != "end_node":
		i += 1
		
	var last_comm = get_child(i)
	
	while new_comms.get_child_count() != 0:
		var steal : Node2D = new_comms.get_child(0)
		new_comms.remove_child(steal)
		add_sibling(steal)
		
	
func _on_delay_timer_timeout():
	do_next()
