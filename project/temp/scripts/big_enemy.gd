extends "res://temp/scripts/enemy.gd"

func _ready():
	speed = 100  # Slower speed for a big enemy.
	accel = 5  # Lower acceleration for a big enemy.
	health = 3  # More health for a big enemy.
	point_value = 100
	
