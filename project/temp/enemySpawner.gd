extends Marker2D

var enemy = preload("res://temp/Enemy.tscn");

func _on_enemy_spawner_timeout():
	var enemy_instance = enemy.instantiate()
	get_parent().add_child(enemy_instance)
	enemy_instance.global_position = global_position
