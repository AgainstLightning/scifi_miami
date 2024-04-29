extends Node

@onready var enemy = preload("res://take3/scenes/Enemy.tscn")
@onready var big_enemy = preload("res://take3/scripts/big_enemy.gd")

var enemies = {}

func _ready():
	var file = FileAccess.open("res://take3/assets/enemies.json", FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var data = json.parse_string(content)
	
	enemies = data.enemies

func _on_timer_timeout():
	var roll = randi() % 10
	var enemy_rarity = "uncommon" if roll == 9 else "common"
	var potential_enemies = enemies[enemy_rarity]
	var enemy_config = potential_enemies[randi() % potential_enemies.size()]
	var enemy_instance = enemy.instantiate()
	enemy_instance.setup(enemy_config)
	get_parent().add_child(enemy_instance)
	enemy_instance.global_position = self.global_position
