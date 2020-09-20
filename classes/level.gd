extends Node2D
class_name Level

export var track: String = "start_the_switch"
export var bpm: int = 140
export var measures: int = 2
export var colors: PoolColorArray = []
export var tile_names: PoolStringArray = []

var id: int = 0
var checkpoint: Node2D

signal color_changed(id, collision_layer, color)

func _ready():
	var background = preload("res://scenes/bck.tscn").instance()
	connect("color_changed", background, "on_color_changed")
	add_child(background)
	
	var camera = Camera2D.new()
	camera.name = "Camera"
	camera.smoothing_enabled = true
	camera.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
	add_child(camera)
	camera.make_current()
	
	var player = preload("res://scenes/player.tscn").instance()
	if get_node("Spawner") != null:
		player.position = get_node("Spawner").position
		checkpoint = get_node("Spawner")
	player.get_node("Change").lifetime = 60.0 / bpm * measures
	add_child(player)
	connect("color_changed", player, "on_color_changed")
	player.get_node("VisibilityNotifier2D").connect("screen_exited", self, "check_camera")
	
	for spike in get_tree().get_nodes_in_group("Spikes"):
		if spike.id != -1:
			connect("color_changed", spike, "on_color_changed")
	
	for checkp in get_tree().get_nodes_in_group("Checkpoints"):
		checkp.connect("player_checked", self, "on_player_checked")
	
	MusicPlayer.play(track, bpm, measures)
	MusicPlayer.connect("measure", self, "change_color")
	
	emit_signal("color_changed", 0, 1, colors[0])


func change_color():
	if id + 1 > colors.size() - 1:
		id = 0
	else:
		id += 1
	
	var collision = StaticBody2D.new()
	if id == 0:
		collision.collision_layer = 1
		collision.collision_mask = 1
	else:
		collision.collision_layer = pow(2, id)
		collision.collision_mask = pow(2, id)
	
	emit_signal("color_changed", id, collision.layers, colors[id])
	
	for tile_id in colors.size():
		var tile = get_node(tile_names[tile_id])
		tile.modulate = colors[tile_id]
		if tile_id != id:
			tile.modulate *= 0.5


func check_camera():
	get_node("Camera").position = Vector2(floor(get_node("Player").position.x / 240) * 240, floor(get_node("Player").position.y / 135) * 135)


func on_player_checked(node):
	checkpoint = node


func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("quit"):
		get_tree().quit()
