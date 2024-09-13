extends Resource
class_name block

#resource containing information of a block to be placed on the upgrade grid
#ill store all of the possible blocks as nodes

enum UpgradeType {POWER_BOMB, SHIELD, OPTION, NONE}


@export var block_type : String = "default_block"

@export var upgrade : UpgradeType = UpgradeType.NONE

#dont think this will work, its cyclical. plus im keeping them as nodes now anyways.
#@export var block_node : PackedScene

@export var grid_shape : Array[Vector2i]			#set of positions for the block.
													#a vertical line would be (0,0), (0,1), (0,2)
@export var block_value : int						#amount of upgrade
