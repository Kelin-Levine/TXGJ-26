class_name Alien
extends RapierRigidBody2D

@export var ground_move_power: Curve
@export var air_move_power: Curve
@export var jump_power: float
@export var base_mass: float = 1.0
@export var added_mass: float = 0.0
@export var chain_links: int = 5

@export var follower_scene: PackedScene
@export var chain_scene: PackedScene

@onready var sprite: Sprite2D = $Sprite2D
@onready var ground_test: ShapeCast2D = $GroundTest

var followers: Array[Follower] = []
var chain_joint: RapierPinJoint2D = null

var action_vector_zero_last: bool = true


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _process(_delta: float) -> void:
	if ground_test.is_colliding():
		sprite.flip_h = linear_velocity.x < 0.0


func _physics_process(_delta: float) -> void:
	# Collect inputs
	var move_down: float = Input.get_action_strength(&"p1_move_down")
	var move_lr: float = Input.get_axis(&"p1_move_left", &"p1_move_right")
	var move_vector: Vector2 = Input.get_vector(&"p1_move_left", &"p1_move_right",
												&"p1_move_up", &"p1_move_down")
	var action_vector: Vector2 = Input.get_vector(&"p1_action_left", &"p1_action_right",
													&"p1_action_up", &"p1_action_down")
	var action_vector_zero := action_vector.is_zero_approx()

	var do_jump: bool = Input.is_action_just_pressed(&"p1_jump")
	var start_recall: bool = Input.is_action_just_pressed(&"p1_recall")

	var do_action_mouse: bool = Input.is_action_just_pressed(&"p1_action_mouse")
	var do_action_button: bool = Input.is_action_just_pressed(&"p1_action_button")
	var do_action_vector: bool = action_vector_zero_last and not action_vector_zero
	var stop_action_mouse: bool = Input.is_action_just_released(&"p1_action_mouse")
	var stop_action_button: bool = Input.is_action_just_released(&"p1_action_button")
	var stop_action_vector: bool = action_vector_zero and not action_vector_zero_last

	# "Pull" action
	mass = base_mass + (added_mass * move_down * (1 if has_chain() else 0))

	# Moving left/right
	var move_power := ground_move_power if ground_test.is_colliding() else air_move_power
	var move_sample: float
	if move_lr > 0.0:
		move_sample = move_power.sample(maxf(0.0, linear_velocity.x)) * move_lr
	else:
		move_sample = move_power.sample(-minf(0.0, linear_velocity.x)) * move_lr
	apply_central_force(Vector2(move_sample * mass, 0.0))

	# Jump
	if do_jump and ground_test.is_colliding():
		# Uncomment for funny
		#var power := jump_power
		#var collision = ground_test.get_collider(0)
		#if collision is RigidBody2D:
		#	power /= 2
		#	collision.apply_impulse(Vector2(0.0, power / 10), ground_test.get_collision_point(0))
		#apply_impulse(Vector2(0.0, -power))
		apply_impulse(Vector2(0.0, -jump_power * mass))

	# Throw chain
	if do_action_mouse:
		spawn_chain(global_position.angle_to_point(get_global_mouse_position()))
	elif do_action_vector:
		spawn_chain(action_vector.angle())
	elif do_action_button:
		spawn_chain(move_vector.angle())

	# Release chain
	if stop_action_mouse or stop_action_vector or stop_action_button:
		release_chain()

	# Extra check for recovering guys
	if start_recall:
		var colliding := get_colliding_bodies()
		for body in colliding:
			_on_body_entered(body)

	# Finalize
	action_vector_zero_last = action_vector_zero


func _on_body_entered(body: Node) -> void:
	if body is StrayFollower or (body is ChainLink and Input.is_action_pressed(&"p1_recall")):
		convert_to_follower(body)


func convert_to_follower(node: Node2D) -> void:
	var follower: Follower = follower_scene.instantiate()
	follower.original = node
	follower.alien = self
	get_parent().add_child(follower)
	followers.append(follower)
	node.queue_free()


func spawn_chain(at_rotation: float) -> void:
	var num_followers := followers.size()
	if not has_chain() and num_followers > 0:
		var num_links := mini(num_followers, chain_links)
		for i in range(num_links):
			followers.pop_back().queue_free()
		var chain: Chain = chain_scene.instantiate()
		chain.global_position = global_position
		chain.rotation = at_rotation
		get_parent().add_child(chain)
		chain_joint = chain.build_chain(num_links, self)


func release_chain() -> void:
	if has_chain():
		var chain := chain_joint.get_parent()
		chain_joint.queue_free()
		chain_joint = null
		if chain.has_method(&"release_chain"):  # almost certainly redundant but im scared
			chain.release_chain()


func has_chain() -> bool:
	return chain_joint != null
