extends Area2D

signal player_checked(checkpoint)

func _on_body_entered(body):
	if body is Player:
		emit_signal("player_checked", self)
