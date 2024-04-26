extends StaticBody2D

var velocity: Vector2

func launch(direction, speed):
	velocity = direction * speed

func _physics_process(delta):  
	var collision = move_and_collide(velocity)    

	if collision != null:
		collision.get_collider().damage()    
		queue_free()  

