extends "res://temp/scripts/enemy.gd"

func _ready():
	speed = 300  # Slower speed for a big enemy.
	accel = 20  # Lower acceleration for a big enemy.
	health = 1  # More health for a big enemy.
	point_value = 25
