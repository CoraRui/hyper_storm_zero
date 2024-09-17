extends Node2D
class_name gun_bullet


func _on_kill_timer_timeout():
	queue_free()
