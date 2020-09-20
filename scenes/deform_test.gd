tool
extends Node2D

export var motion: Vector2
export var points: int = 16
export var radius: float = 3.0


func _process(_delta):
	update()


func _draw():
	var vectors: PoolVector2Array = []
	var colors: PoolColorArray = []
	
	for point in points:
		var vector = Vector2(cos(point / float(points) * PI * 2.0) * radius, sin(point / float(points) * PI * 2.0) * radius)
		vector *= motion
		vectors.append(vector)
		colors.append(Color(1, 1, 1))
	
	draw_polygon(vectors, colors)
