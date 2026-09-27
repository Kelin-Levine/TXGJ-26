class_name ChainLink
extends RapierRigidBody2D

@export var sticky: bool: get = get_sticky, set = set_sticky
@export var stick_softness: float = 0.0

@onready var stick_test: ShapeCast2D = $StickTest

var stick_joint: RapierPinJoint2D = null
var _sticky: bool = false


func _ready() -> void:
	set_sticky(_sticky)


func _physics_process(_delta: float) -> void:
	if sticky and stick_joint == null:
		var stick_collisions := stick_test.get_collision_count()
		for i in range(stick_collisions):
			var collider = stick_test.get_collider(i)
			if collider is PhysicsBody2D:
				stick(collider, stick_test.get_collision_point(i))
				break


func stick(body: PhysicsBody2D, point: Vector2) -> void:
	stick_joint = RapierPinJoint2D.new()
	stick_joint.softness = stick_softness
	add_child(stick_joint)
	stick_joint.global_position = point
	stick_joint.node_a = stick_test.get_path_to(self)
	stick_joint.node_b = stick_test.get_path_to(body)


func launch(power: float) -> void:
	var parent = get_parent()
	if parent is Node2D:
		apply_central_impulse(Vector2.from_angle(parent.global_rotation) * power)


func get_sticky() -> bool:
	return _sticky


func set_sticky(value: bool) -> void:
	_sticky = value
	if stick_test != null:
		stick_test.enabled = sticky
