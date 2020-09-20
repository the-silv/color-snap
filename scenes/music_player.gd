extends Node


export var first_load: String = ""
export var first_bpm: int = 140
export var first_measures: int = 2
var current_track: String = ""

signal measure()

func _ready() -> void:
	play(first_load, first_bpm, first_measures)


func play(track: String, bpm: int, measures: int):
	if track != current_track:
		if current_track != "":
			get_node(current_track).queue_free()
			get_node(current_track + "_timer").queue_free()
		
		var timer = Timer.new()
		timer.name = track + "_timer"
		timer.wait_time = 60.0 / bpm * measures
		timer.connect("timeout", self, "emit_signal", ["measure"])
		add_child(timer)
		timer.start()
		
		var new_player = AudioStreamPlayer.new()
		new_player.name = track
		new_player.stream = load("res://audio/" + track + ".wav")
		new_player.autoplay = true
		new_player.bus = "Music"
		add_child(new_player)
		
		current_track = track
