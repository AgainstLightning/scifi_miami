extends CharacterBody2D
var bullet = preload("res://temp/Bullet.tscn")

func _physics_process(delta):
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("shoot"):
		var bullet_instance = bullet.instantiate()
		print(bullet_instance)
		get_tree().root.add_child(bullet_instance)
		var direction_to_mouse = (get_global_mouse_position() - global_position).normalized()
		bullet_instance.launch(direction_to_mouse, 40)
