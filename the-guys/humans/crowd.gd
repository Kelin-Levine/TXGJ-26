class_name Crowd
extends Node2D

@export var min_followers: int = 5
@export var max_followers: int = 10
@export var vertical_offset: float = 0.0

@export var stray_follower_scene: PackedScene


func _ready() -> void:
	var visual := get_node_or_null(^"Visual")
	if visual != null:
		visual.queue_free()
	var followers := randi_range(min_followers, max_followers)
	for i in range(followers):
		spawn_follower()
	child_order_changed.connect(_check_children)


func _check_children() -> void:
	# Delete self if all children are gone
	if get_child_count() == 0:
		queue_free()


func spawn_follower() -> void:
	var follower: StrayFollower = stray_follower_scene.instantiate()
	add_child(follower)
	follower.global_position = global_position + Vector2(
		randf_range(-50.0, 50.0) * global_scale.x,
		vertical_offset
	)
