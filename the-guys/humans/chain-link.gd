class_name ChainLink
extends RapierRigidBody2D

@export var sticky: bool: get = get_sticky, set = set_sticky
@export var back_sticky: bool: get = get_back_sticky, set = set_back_sticky
@export var stick_softness: float = 0.0

@onready var stick_test: ShapeCast2D = $StickTest
@onready var back_stick_test: ShapeCast2D = $BackStickTest

var stick_joint: RapierPinJoint2D = null
var back_stick_joint: RapierPinJoint2D = null
var _sticky: bool = false
var _back_sticky: bool = false


func _ready() -> void:
	set_sticky(_sticky)
	set_back_sticky(_back_sticky)


func _physics_process(_delta: float) -> void:
	if _sticky and not is_stuck():
		stick_joint = _check_stick(stick_test)
	if _back_sticky and not is_back_stuck():
		back_stick_joint = _check_stick(back_stick_test)


func _check_stick(tester: ShapeCast2D) -> RapierPinJoint2D:
	var stick_collisions := tester.get_collision_count()
	for i in range(stick_collisions):
		var collider = tester.get_collider(i)
		if collider is PhysicsBody2D:
			return stick(tester, collider, tester.get_collision_point(i))
	return null



func stick(tester: Node, body: PhysicsBody2D, point: Vector2) -> RapierPinJoint2D:
	var joint := RapierPinJoint2D.new()
	joint.softness = stick_softness
	add_child(joint)
	joint.global_position = point
	joint.node_a = tester.get_path_to(self)
	joint.node_b = tester.get_path_to(body)
	return joint


func un_stick() -> void:
	if is_stuck():
		stick_joint.queue_free()


func un_back_stick() -> void:
	if is_back_stuck():
		back_stick_joint.queue_free()


func launch(power: float) -> void:
	var parent = get_parent()
	if parent is Node2D:
		apply_central_impulse(Vector2.from_angle(parent.global_rotation) * power)


func is_stuck() -> bool:
	return stick_joint != null


func is_back_stuck() -> bool:
	return back_stick_joint != null


func get_sticky() -> bool:
	return _sticky


func get_back_sticky() -> bool:
	return _back_sticky


func set_sticky(value: bool) -> void:
	_sticky = value
	if stick_test != null:
		stick_test.enabled = _sticky
		if not _sticky:
			un_stick()


func set_back_sticky(value: bool) -> void:
	_back_sticky = value
	if back_stick_test != null:
		back_stick_test.enabled = _back_sticky
		if not _back_sticky:
			un_back_stick()
