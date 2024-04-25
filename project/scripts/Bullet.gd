extends Node2D

@export var SPEED = 2500
var direction = Vector2.ZERO

func _ready():
	set_as_top_level(true)

func _process(delta):
	position += direction * SPEED * delta  # Move in the set direction

func set_direction(dir: Vector2):
	direction = dir.normalized()
	rotation = dir.angle_to(Vector2.RIGHT)  # This aligns the bullet's forward direction with the trajectory

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
