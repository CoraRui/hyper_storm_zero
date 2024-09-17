extends Node2D
class_name shmup_player

#TODO: i frames on respawn

#TODO: add options, shields, power bombs, fire rate boost, speed boosts, and money boosts(in enemy loader) 
#TODO: add dog shooting sound if a dog statue is possessed
#the options and shields might be a little tough.
#the options should be self contained little things. just a little thing that fires when the player hits the fire button, in the same 
#way that the player fires. it should follow a specified node a certain distance behind it. the first will follow the player, the second will
#follow the first, etc.
#the shields will be a counter in the health script. there'll be some sort of animation, with like lines around the player. each hit will eb a line

#the way that the shield will work is completely contained to this. ill have an integer that gets set on ready for how many hits the player can take.
#when the player is hit, that count is deducted, they get iframes, then they can get hit again.
#once their shield is at zero, they can be destroyed.
#shields dont regenerate beyond lives. cause that would be busted.

#input will be pretty similar to arpg player i think actually. right? its mostly the animation level design and 
#attack mechanism thats different

#region movement exports
@export_group("movement")
@export var m_node : Node2D
@export var v_vec : Vector2i = Vector2i(1,1)		#number of pixels to move each movement
@export var v_skip : Vector2i = Vector2i(2,2)		#number of frames to wait before moving
var point_dir : Vector2i = Vector2i(0,0)
@export var frame_index : int = 0			#current frame in frame cycle
@export var frame_cap : int = 100			#max frames in frame cycle
@export var frozen : bool = false
@export var col_box : collision_box
@export_group("","")
#endregion

@export_group("health+iframes")
var inv_flash : int = 3
var dying : bool = false
var iframes : int = 0
@export_group("","")

#region overshield exports
@export_group("overshield")
@export var shield_anim : AnimatedSprite2D
@export var shield_hit_sf : sf_link
var shield_left : int = 0		#this value gets set on ready, number of hits player can take before death
@export_group("","")
#endregion

@export var player_anim : AnimatedSprite2D
@export var laser_gi : laser_gun 
@export var power_bi : power_bomb

#region autoloads
@onready var shmup_hi : shmup_health = get_node("/root/shmup_health_auto")
@onready var save_mi : save_manager = get_node("/root/save_manager_auto")
@onready var sfx_pi : sfx_player = get_node("/root/sfx_player_auto")
#endregion

func _ready():
	load_upgrades()
	trigger_iframes(120)

func _input(event):
	collect_input(event)

func _physics_process(_delta):
	move()
	inc_frame()
	if iframes > 0:
		if iframes % inv_flash == 0:
			set_visible(!visible)
		iframes -= 1
		if iframes == 0:
			print("iframes finished")
			set_visible(true)

func move() -> void:
	#x movement
	if frame_index % v_skip.x == 0:
		var x : int = point_dir.x
		if col_box.left_area.has_overlapping_areas():
			x = clampi(x, 0, 100)
		if col_box.right_area.has_overlapping_areas():
			x = clampi(x, -100, 0)
		m_node.global_position.x += v_vec.x * x
	
	#y movement
	if frame_index % v_skip.x == 0:
		var y : int = point_dir.y
		if col_box.down_area.has_overlapping_areas():
			y = clampi(y, -100, 0)
		if col_box.up_area.has_overlapping_areas():
			y = clampi(y, 0, 100)
		m_node.global_position.y += v_vec.y * y

func load_upgrades() -> void:
	#what upgrades? fire rate, ship speed, money drop(not here), power bomb, shields, options, dog
	
	#if the player has the dog statue, change the shoot sound effect to a bark
	if save_mi.file_01.dog_statue > 0:
		laser_gi.shoot_sf.sf_name = "ruff!:3"
		
	#give overshields
	shield_left = save_mi.file_01.shields
	if shield_left > 0:
		shield_anim.play("shield")
	
	#set ship speed
	match save_mi.file_01.speed_up:
		0:
			v_vec = Vector2i(1,1)
			v_skip = Vector2i(3,3)
			print("speed 0")
		1:
			v_vec = Vector2i(1,1)
			v_skip = Vector2i(2,2)
			print("speed 1")
		2:
			v_vec = Vector2i(1,1)
			v_skip = Vector2i(1,1)
			print("speed 2")
		3:
			v_vec = Vector2i(2,2)
			v_skip = Vector2i(1,1)
		_:
			print("oob speed")
	
	#set fire rate
	match save_mi.file_01.rate_up:
		#TODO: shot count to extend to options
		0:
			laser_gi.shot_count = 3
			laser_gi.shot_rem = 3
		1:
			laser_gi.shot_count = 5
			laser_gi.shot_rem = 5
		2:
			laser_gi.shot_count = 7
			laser_gi.shot_rem = 7
		3:
			laser_gi.shot_count = 9
			laser_gi.shot_rem = 9
	
	#give right amount of power bombs
	power_bi.bomb_count = save_mi.file_01.power_bombs
	
func inc_frame() -> void:
	frame_index = cmath.cycle_int(frame_index + 1, 0, frame_cap)

func collect_input(e : InputEvent) -> void:
	if frozen:
		return
	
	if e.is_action_released("up") || e.is_action_released("down") || e.is_action_released("left") || e.is_action_released("right"):
		point_dir = Vector2i(0,0)
		player_anim.stop()
	
	if Input.is_action_pressed("up"):
		point_dir.y = -1
	if Input.is_action_pressed("down"):
		point_dir.y = 1
	if Input.is_action_pressed("left"):
		point_dir.x = -1
	if Input.is_action_pressed("right"):
		point_dir.x = 1
	
func freeze(b : bool) -> void:
	frozen = b
	if b:
		point_dir = Vector2i(0,0)

func trigger_iframes(f : int):
	#f is number of frames to be invincible
	iframes = f

func _on_hit_area_area_entered(_area):
	#make sure that the player hasnt already been destroyed and that they dont have i frames
	if !dying && iframes <= 0:

		if shield_left <= 0:
			shmup_hi.hit()
			sfx_pi.play_effect(shield_hit_sf)
			dying = true
		else:
			if shield_left == 1:
				shield_anim.play("no_shield")
			shield_left -= 1
			trigger_iframes(40)
			#TODO: activate iframes

