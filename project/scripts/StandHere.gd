extends Node

func _on_body_entered(body):
	$Greeting.visible = true

func _on_body_exited(body):
	$Greeting.visible = false
