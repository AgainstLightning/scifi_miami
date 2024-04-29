extends CharacterBody2D

var size = Vector2(0.5, 0.5)
var color = Color.RED
var speed = 200

const COLOR_MAP = {
	"RED": Color.RED,
	"GREEN": Color.GREEN,
	"BLUE": Color.BLUE,
	"GOLD": Color.GOLD,
	"PURPLE": Color.PURPLE
}

func setup(config):
	scale = Vector2(config.size, config.size)
	$Sprite2D.modulate = COLOR_MAP[config.color]
	speed = -config.speed
	
func _physics_process(delta):
	var movement = Vector2(0, speed) * delta
	move_and_collide(movement)
