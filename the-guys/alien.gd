class_name Alien
extends RigidBody2D

@export var ground_move_power: Curve
@export var air_move_power: Curve
@export var jump_power: float

@onready var sprite: Sprite2D = $Sprite2D
@onready var ground_test: ShapeCast2D = $GroundTest


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	if ground_test.is_colliding():
		sprite.flip_h = linear_velocity.x < 0.0


func _physics_process(delta: float) -> void:
	var move_lr: float = Input.get_axis(&"p1_move_left", &"p1_move_right")
	var jump: bool = Input.is_action_just_pressed(&"p1_jump")
	var action_mouse: bool = Input.is_action_just_pressed(&"p1_action_mouse")
	var action_button: bool = Input.is_action_just_pressed(&"p1_action_button")
	var action_axis: Vector2 = Input.get_vector(&"p1_action_left", &"p1_action_right", &"p1_action_up", &"p1_action_down")

	var move_power := ground_move_power if ground_test.is_colliding() else air_move_power
	var move_sample: float
	if move_lr > 0.0:
		move_sample = move_power.sample(maxf(0.0, linear_velocity.x)) * move_lr
	else:
		move_sample = move_power.sample(-minf(0.0, linear_velocity.x)) * move_lr
	apply_central_force(Vector2(move_sample, 0.0))

	if jump and ground_test.is_colliding():
		apply_impulse(Vector2(0.0, -jump_power))
