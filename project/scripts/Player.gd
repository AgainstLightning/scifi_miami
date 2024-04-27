extends CharacterBody2D

@export var MAX_SPEED = 700
@export var ACCELERATION = 5000
@export var FRICTION = 4000
@export var MAX_ROTATION_SPEED = 10.0
@export var ROLL_SPEED = 1400
@export var ROLL_DURATION = 0.3
var rolling = false
var roll_timer = 0.0
var roll_direction = Vector2.ZERO

@onready var axis = Vector2.ZERO

var bullet = preload("res://temp/Bullet.tscn")

func _physics_process(delta):
	roll_or_move(delta)
	rotate_towards_mouse(delta)
	check_for_shoot()

func check_for_shoot():
	if Input.is_action_just_pressed("shoot") and not rolling:
		var bullet_instance = bullet.instantiate()
		print(bullet_instance)
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = $Gun.global_position
		var direction_to_mouse = (get_global_mouse_position() - global_position).normalized()
		bullet_instance.launch(direction_to_mouse, 40)
		
func roll_or_move(delta):
	if Input.is_action_just_pressed("roll") and not rolling:
		start_roll()
		
	if not rolling:
		move(delta)
	else:
		perform_roll(delta)
	
func start_roll():
	update_input_axis()
	roll_direction = axis.normalized()
	if roll_direction.length() == 0:
		roll_direction = Vector2(1, 0) # Default to rolling right if no direction is pressed
	rolling = true
	roll_timer = ROLL_DURATION

func perform_roll(delta):
	roll_timer -= delta
	if roll_timer <= 0:
		rolling = false
		velocity = Vector2.ZERO
	else:
		velocity = roll_direction * ROLL_SPEED
	move_and_slide()

func rotate_towards_mouse(delta):
	var target_angle = (get_global_mouse_position() - global_position).angle()
	var diff_angle = wrapf(target_angle - rotation, -PI, PI)
	var rotation_direction = sign(diff_angle)
	var rotation_amount = min(MAX_ROTATION_SPEED * delta, abs(diff_angle))
	
	rotation += rotation_amount * rotation_direction

func update_input_axis():
	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
func move(delta):
	update_input_axis()
	
	if axis == Vector2.ZERO:
		apply_friction(FRICTION * delta)
	else:
		apply_movement(axis.normalized() * ACCELERATION * delta)
	
	move_and_slide()

func apply_friction(amount):
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
		
	else:
		velocity = Vector2.ZERO
		
func apply_movement(accel):
	velocity += accel
	velocity = velocity.limit_length(MAX_SPEED)
