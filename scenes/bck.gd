extends CanvasLayer


func on_color_changed(_id, _collision_layer, color):
	$ColorRect.color = color * 0.4
