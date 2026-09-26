class_name Interpify
extends Node

@export var target: Node2D: get = get_target, set = set_target
@export var rate: float = 1.0

var _target: Node2D = null


func _ready() -> void:
	set_target(_target)


func _process(delta: float) -> void:
	var c: Node2D = get_parent()
	c.global_position = target.global_position + (c.global_position - target.global_position)*exp(-rate*delta)


func get_target() -> Node2D:
	return _target


func set_target(node: Node2D) -> void:
	_target = node
	if _target == null:
		push_warning("Chasify has null target")
