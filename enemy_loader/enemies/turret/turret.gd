extends Node2D

#sits in a spot. points at the player. shoots a bullet at them.
#in 


@export var head_node : Node2D

@export var bp : Node2D

@export var pin_timer : Timer

@export var tbull : PackedScene

@onready var player_li : player_loader = get_node("/root/player_loader_auto")

func _physics_process(_delta):
	turn_head()

func turn_head() -> void:
	
	var p_ins : Node2D = player_li.player_ins
	if !is_instance_valid(p_ins):
		return
	var angle : float = -1 * rad_to_deg(get_angle_to(p_ins.global_position))
	
	if p_ins.global_position.x > global_position.x:
		if p_ins.global_position.y < global_position.y:
			if angle < 22.5:
				head_node.rotation = deg_to_rad(-90)
			elif angle > 22.5 && angle < 67.5:
				head_node.rotation = deg_to_rad(-135)
			else:
				head_node.rotation = deg_to_rad(-180)
				
		else:
			angle *= -1
			if angle >= 0 && angle < 22.5:
				head_node.rotation = deg_to_rad(-90)
			elif angle > 22.5 && angle < 45:
				head_node.rotation = deg_to_rad(-45)
			else:
				head_node.rotation = deg_to_rad(0)
	else:
		if p_ins.global_position.y < global_position.y:
			if angle >= 90 && angle < 112.5:
				head_node.rotation = deg_to_rad(-180)
			elif angle > 112.5 && angle < 135:
				head_node.rotation = deg_to_rad(-225)
			else:
				head_node.rotation = deg_to_rad(-270)
		else:
			angle *= -1
			if angle > 112.5 && angle < 157.5:
				head_node.rotation = deg_to_rad(-315)
			elif angle > 157.5 && angle <= 181:
				head_node.rotation = deg_to_rad(-270)
			else:

				head_node.rotation = deg_to_rad(0)
	
func shoot() -> void:
	if !is_instance_valid(player_li.player_ins):
		return
	
	if global_position.distance_to(player_li.player_ins.global_position) >= 100:
		return
	
	var bullet_ins : Node2D = tbull.instantiate()
	get_tree().get_root().add_child.call_deferred(bullet_ins)
	bullet_ins.global_position = bp.global_position
	
func _on_shoot_timer_timeout():
	shoot()
