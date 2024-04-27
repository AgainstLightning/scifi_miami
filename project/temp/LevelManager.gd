extends Node2D

var score = 0

@onready var score_label = get_node("../UI/Score")

func _ready():
	get_node("../SignalBus").connect("enemy_killed", on_enemy_killed)
	
func on_enemy_killed(point_value: int):
	print(point_value)
	score += point_value
	update_score_ui()

func update_score_ui():
	score_label.text = str(score)
