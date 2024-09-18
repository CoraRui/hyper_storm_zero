extends Node2D
class_name node_command

#enclosing resource type for a single node_command. can have multiple command types in it.
#should i include multiple commands in single node commands? might be convienient. later maybe.
#i mean the whole reason i separated each individual commands as children of node_command was to have overarching functions for each command. so
#i guess it would be nice to have groups of commands that could have that logic applied to them as well.

func get_command():
	#this almost feels redundant since i could just call get_child. but i dont think it hurts in the case that i want to other checks in
	#the future. rather not have to replace everything later.
	#cant type return cause its got multiple... way it is though.
	return get_child(0)







