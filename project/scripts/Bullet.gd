#CharacterBody and RigidBody would also work, but you probably don't need their extra functionality
extends StaticBody2D    
class_name Bullet

var speed = 2500
  
#You can use this signal to alert other nodes that the bullet hit something
signal hit_something  

#Variable for keeping track of it's velocity        
var velocity:Vector2    

#Set the velocity of the bullet  
#Call this right after creating the bullet to make it start moving
func set_direction(direction:Vector2):    
	velocity = direction * speed    

#This is automatically called every physics update.
func _physics_process(delta):  
	#Move the bullet using it's previously defined velocity  
	#And save any collisions that may happen.
	var collision = move_and_collide(velocity)    

	#If it hit something, emit the signal from earlier
	if collision != null:    
		hit_something.emit()    
		#Then delete the bullet  
		queue_free()  
