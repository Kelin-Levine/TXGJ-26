class_name Chaseify
extends Node

@export var target: RigidBody2D: get = get_target, set = set_target
@export var rate: float = 1.0
@export var runahead: float = 1.0

var _target: RigidBody2D = null


func _ready() -> void:
	set_target(_target)


func _process(delta: float) -> void:
	var c: Node2D = get_parent()
	var t_pos: Vector2 = target.global_position + target.linear_velocity * runahead
	c.global_position = t_pos + (c.global_position - t_pos)*exp(-rate*delta)


func get_target() -> RigidBody2D:
	return _target


func set_target(node: RigidBody2D) -> void:
	_target = node
	if _target == null:
		push_warning("Chasify has null target")
