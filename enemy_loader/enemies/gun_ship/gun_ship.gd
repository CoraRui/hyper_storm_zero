extends Node2D
class_name gun_ship

#hovers around the top of the screen and shoots bullets.


#the bullets work by having timed cycles, on and off

@export var bp : Node2D
@export var bullet_ref : PackedScene
@export var shoot_delay : int = 4

@export var left_pos : Vector2i = Vector2i(10, 10)
@export var right_pos : Vector2i = Vector2i(115, 115)
@export var speed : int = 1
var go_left : bool = false

@export var shoot_timer : Timer
@export var pause_timer : Timer

var shoot_yes : bool = false
var shoot_left : bool = true
var bullet_frame : int = 0
var leaving : bool = false		#indicates that the ship should move up out of frame.

@onready var scene_mi : scene_manager = get_node("/root/scene_manager_auto")
@onready var music_pi : music_player = get_node("/root/music_player_auto")

func _physics_process(_delta):
	bullet_frame += 1
	if bullet_frame >= shoot_delay:
		bullet_frame = 0
		
	move()
	if leaving:
		global_position.y -= 3
	else:
		if bullet_frame == 0 && shoot_yes:
			shoot()

func shoot():
	var new_bullet : Node2D = bullet_ref.instantiate()
	get_tree().get_root().add_child.call_deferred(new_bullet)
	new_bullet.global_position = bp.global_position
	
	if shoot_left:
		new_bullet.global_position.x += 9
		shoot_left = false
	else:
		shoot_left = true
	
func move():
	if go_left:
		position = position.move_toward(left_pos, speed)
		
		if position.distance_to(left_pos) < 5:
			go_left = false
	else:
		position = position.move_toward(right_pos, speed)
		
		if position.distance_to(right_pos) < 5:
			go_left = true
	
func _on_pause_timer_timeout():
	shoot_yes = true
	shoot_timer.start()

func _on_shoot_timer_timeout():
	shoot_yes = false
	pause_timer.start()
	
func _on_leave_timer_timeout():
	leaving = true
	
func _on_expire_timer_timeout():
	queue_free()
	
func _on_enemy_health_dead():
	if scene_mi.current_scene is level_one:
		scene_mi.current_scene.level_clear()
