class_name Alien
extends RapierRigidBody2D

@export var ground_move_power: Curve
@export var air_move_power: Curve
@export var jump_power: float

@export var chain_scene: PackedScene

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
		var power := jump_power
		var collision = ground_test.get_collider(0)
		if collision is RigidBody2D:
			power /= 2  # comment for funny
			collision.apply_impulse(Vector2(0.0, power), ground_test.get_collision_point(0))
		apply_impulse(Vector2(0.0, -power))
	
	if action_mouse:
		#get_local_mouse_position()
		#print(get_viewport().get_mouse_position())
		#print(get_global_mouse_position())
		var chain: Node2D = chain_scene.instantiate()
		chain.global_position = get_global_mouse_position()
		get_parent().add_child(chain)
