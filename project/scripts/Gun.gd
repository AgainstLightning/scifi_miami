extends Marker2D
var bullet = preload("res://scenes/bullet.tscn")

func shoot():
	print("shoot")
	var bullet_instance = bullet.instantiate()
	var direction_to_mouse = (get_global_mouse_position() - global_position).normalized()
	bullet_instance.global_position = global_position
	bullet_instance.set_direction(direction_to_mouse)
	add_child(bullet_instance)
