extends CharacterBody2D

@onready var SIGNAL_BUS = get_node("../SignalBus")
var health = 1
var speed = 200
var accel = 10
var point_value = 50

func _physics_process(delta):
	var direction = Vector2.ZERO
	var agent = $NavigationAgent2D
	
	agent.target_position = get_node("../Player").global_position
	direction = agent.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction * speed, accel * delta)
	
	move_and_slide()
	
func damage():
	health -= 1
	if health == 0:
		SIGNAL_BUS.emit_signal("enemy_killed", point_value)
		queue_free()
