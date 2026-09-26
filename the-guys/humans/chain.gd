class_name Chain
extends Node2D

@export var num_links: int = 1
@export var sprite_height: float
@export var sprite_overlap: float

var link_scene: PackedScene = preload("uid://deech6nqsx2xg")


func _ready() -> void:
	# doesn't work lmao
	var a := add_link(0)
	var b: PhysicsBody2D
	for i in range(num_links):
		b = add_link(i+1)
		add_joint(i+1, a, b)
		a = b


func add_link(index: int) -> PhysicsBody2D:
	var link := link_scene.instantiate()
	add_child(link)
	link.position.y = (sprite_height - sprite_overlap) * index + (sprite_overlap - sprite_height) / 2
	return link


func add_joint(index: int, node_a: PhysicsBody2D, node_b: PhysicsBody2D) -> RapierPinJoint2D:
	var joint := RapierPinJoint2D.new()
	add_child(joint)
	joint.position.y = (sprite_height - sprite_overlap) * index
	joint.joint_type = 1
	joint.node_a = joint.get_path_to(node_a)
	joint.node_b = joint.get_path_to(node_b)
	return joint
