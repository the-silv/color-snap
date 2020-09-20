extends ControlledBody2D
class_name Player

export var walk_accel: int = 512
export var walk_max: int = 64
export var gravity_accel: int = 256
export var gravity_max: int = 128
export var ground_friction: int = 16
export var air_friction: int = 8
export var dash_power: int = 100

var color: Color = Color(1, 1, 1)
var can_dash: bool = false
var end: Node2D



func _physics_process(delta: float) -> void:
	var inputs = [Vector2(), false]
	if Input.is_action_pressed("up"):
		inputs[0].y -= Input.get_action_strength("up")
	if Input.is_action_pressed("down"):
		inputs[0].y += Input.get_action_strength("down")
	if Input.is_action_pressed("left"):
		inputs[0].x -= Input.get_action_strength("left")
	if Input.is_action_pressed("right"):
		inputs[0].x += Input.get_action_strength("right")
	
	if Input.is_action_just_pressed("dash"):
		inputs[1] = true
	
	impulse_x(inputs[0].x * delta * walk_accel, inputs[0].x * walk_max)
	if is_on_floor():
		impulse_y(gravity_accel * delta * 0.1, gravity_max)
		can_dash = true
	else:
		impulse_y(gravity_accel * delta, gravity_max)
		snap = Vector2(0, 1)
	
	if inputs[0].x == 0:
		friction_x(ground_friction)
	
	if inputs[1] and can_dash:
		snap = Vector2()
		if !is_on_floor():
			can_dash = false
			$Jump.emitting = true
		motion = Vector2.ZERO
		impulse_y(-dash_power, dash_power)
	
	friction_y(0.1)
	
	$Sprite.scale.x = 0.125 + abs(motion.x / 2000)
	$Sprite.scale.y = 0.125 + abs(motion.y / 2000)
	
	if end != null:
		friction_x(40 * delta)
		friction_y(40 * delta)
		snap = Vector2()
		var distance: Vector2 = (end.position - position) * 4
		impulse_x(distance.x, 20)
		impulse_y(distance.y, 20)


func on_color_changed(_id, layer, new_color):
	layers = layer
	modulate = new_color


func die():
	var level = get_tree().get_current_scene()
	
	var death_sprite = Sprite.new()
	death_sprite.texture = preload("res://textures/death.svg")
	death_sprite.scale = Vector2(0.125, 0.125)
	death_sprite.rotation_degrees = rand_range(0, 360)
	death_sprite.global_position = global_position
	death_sprite.z_index = -2
	level.add_child(death_sprite)
	
	self_modulate = Color(1, 1, 1, 0)
	global_position = level.checkpoint.global_position
	self_modulate = Color(1, 1, 1)
	








