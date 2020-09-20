extends Area2D

export var jump_to: String

func _ready() -> void:
	$Tween.interpolate_property($Cutscene/Bck, "color", Color(1, 1, 1), Color(0, 0, 0, 0), 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()


func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.end = self
		$Tween.interpolate_property($Flow, "speed_scale", null, 4.0, 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$Tween.interpolate_property($Cutscene/Bck, "color", null, Color(1, 1, 1), 4.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$Tween.start()
		yield($Tween, "tween_all_completed")
		get_tree().change_scene("res://scenes/" + jump_to + ".tscn")


func _on_body_exited(body: Node) -> void:
	if body is Player:
		body.end = null
		$Tween.interpolate_property($Flow, "speed_scale", null, 1.0, 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$Tween.start()
