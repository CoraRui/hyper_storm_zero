extends Node2D
class_name test_new_comm

#ok. looks lile ill have to find some way to pass a set of node commands to the comm_executor. so i guess id have a packed scene of them.
#so ill have some function in the command executor take a packed scene, then instantiate it and add its children to itself if its a valid thing.


@export var test_set : PackedScene


#region autoloads

@onready var node_ei : node_executor = get_node("/root/node_executor_auto")

#endregion

func _ready():
	node_ei.take_commands(test_set)
	node_ei.do_next()
