class_name Chain
extends Node2D

@export var launch_power: float = 0.0
@export var chain_softness: float = 0.0
@export var link_width: float
@export var link_height: float
@export var link_angle: float
#@export var sprite_height: float
#@export var sprite_overlap: float

@export var link_scene: PackedScene

@onready var sticky_timer: Timer = $ReleaseStickyExpiryTimer

var links: Array[ChainLink] = []


func _ready() -> void:
	sticky_timer.timeout.connect(sticky_expire)


func _check_children() -> void:
	# Delete self if all ChainLink children are gone
	for node in get_children():
		if node is ChainLink:
			return
	queue_free()


func release_chain() -> void:
	var first_link := links[0]
	if is_instance_valid(first_link):
		first_link.back_sticky = true
	sticky_timer.start()


func sticky_expire() -> void:
	var first_link := links[0]
	var last_link := links[-1]
	if is_instance_valid(first_link):
		first_link.back_sticky = false
	if is_instance_valid(last_link):
		last_link.sticky = false


## Returns the first RapierPinJoint2D in the chain (the one connected to first_node).
## Do not call this more than once per instance!
func build_chain(num_links: int, first_node: PhysicsBody2D = null) -> RapierPinJoint2D:
	links = []  # suboptimal but safe
	var first_joint: RapierPinJoint2D = null
	var a: PhysicsBody2D = first_node
	var b: ChainLink = null
	for i in range(0, num_links):
		if a == null:
			a = add_link(i)
			continue
		b = add_link(i)
		var joint := add_joint(i, a, b)
		if first_joint == null:
			first_joint = joint
		a = b
	links[-1].launch(launch_power * num_links)
	links[-1].sticky = true
	child_order_changed.connect(_check_children)
	return first_joint


func add_link(index: int) -> ChainLink:
	var link: ChainLink = link_scene.instantiate()
	add_child(link)
	#link.position.x = ((sprite_height - sprite_overlap) * index
	# - (sprite_overlap - sprite_height) / 2)
	link.position = Vector2(link_width * (index + 1), link_height / 2.0)
	link.rotation_degrees = -link_angle * ((index % 2) * 2 - 1)
	links.append(link)
	return link


func add_joint(index: int, node_a: PhysicsBody2D, node_b: PhysicsBody2D) -> RapierPinJoint2D:
	var joint := RapierPinJoint2D.new()
	joint.softness = chain_softness
	add_child(joint)
	#joint.position.x = (sprite_height - sprite_overlap) * index
	joint.position = Vector2(
		link_width * index + link_width / 2.0,
		link_height * (index % 2)
	)
	joint.node_a = joint.get_path_to(node_a)
	joint.node_b = joint.get_path_to(node_b)
	# TODO: does parenting to node_a or node_b help anything?
	return joint
