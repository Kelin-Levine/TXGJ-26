class_name ChainLink
extends RapierRigidBody2D

@export var launch_power: float = 0.0


func _ready() -> void:
    var parent = get_parent()
    if parent is Node2D:
        apply_central_impulse(Vector2.from_angle(parent.global_rotation) * launch_power)
