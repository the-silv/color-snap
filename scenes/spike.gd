tool
extends Area2D

export var spikes: int = 4
export var id: int = -1
onready var original_pos: float = position.y
var original_color: Color
var player: Player


func _draw():
	for spike in spikes:
		var points: PoolVector2Array = [Vector2(-1, 2), Vector2(0, 0 ), Vector2(1, 2)]
		var colors: PoolColorArray = [Color(1, 1, 1), Color(1, 1, 1), Color(1, 1, 1)]
		
		for point in points.size():
			points[point].x += 2 * spike
			points[point].x -= spikes - 1
		
		draw_polygon(points, colors, PoolVector2Array(), null, null, true)
	
	$Shape.shape.extents.x = spikes

func on_color_changed(current_id, _collision_layers, color):
	if current_id == id:
		self_modulate = color
		original_color = color
		$Tween.interpolate_property(self, "position:y", original_pos + 0.5, original_pos, 0.2, Tween.TRANS_BACK,Tween.EASE_IN_OUT)
		$Tween.start()
		if player != null:
			player.die()
	else:
		self_modulate = original_color * 0.5


func _on_body_entered(body):
	if body is Player:
		if id == -1 or get_tree().get_current_scene().id == id:
			body.die()
		else:
			player = body


func _on_body_exited(body: Node) -> void:
	if body is Player:
		player = null
