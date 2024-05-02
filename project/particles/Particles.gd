extends Node2D

# Preload the explosion particle scene.
@onready var explosion = preload("res://particles/explosion.tscn")

var point_count = 4
var increasing = true
var speed = 20  # Control the speed of the change, lower is faster.

func _ready():
	set_process(true)

func _process(delta):
	# Calculate the amount to change the point_count by, factoring in the delta time and speed.
	var change_amount = delta * speed
	
	# Update the point_count based on the direction of the loop
	if increasing:
		point_count += change_amount
		if point_count >= 20:
			increasing = false
	else:
		point_count -= change_amount
		if point_count <= 4:
			increasing = true
	
	# Request a redraw
	queue_redraw()

func _draw():
	draw_line(Vector2(500, 500), Vector2(700, 700), Color.GREEN, 1.0)
	draw_line(Vector2(1100, 1100), Vector2(1200, 100), Color.GREEN, 2.0)
	draw_circle(Vector2(100, 100), point_count * 3, Color.RED)
	draw_arc(get_global_mouse_position(), 200, 0, TAU, point_count, Color.RED)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var explosion_instance = explosion.instantiate()
		explosion_instance.global_position = get_global_mouse_position()
		print("Instance created at position: ", explosion_instance.global_position)
		add_child(explosion_instance)
		explosion_instance.modulate = Color(randf(), randf(), randf(), 1)  # Random color, full opacity
		explosion_instance.get_node("CPUParticles2D").emitting = true
