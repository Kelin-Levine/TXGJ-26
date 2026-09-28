class_name Follower
extends Sprite2D

@export var min_chase_offset: float = 5.0
@export var max_chase_offset: float = 50.0
@export var chase_rate: float = 1.0
@export var rotation_correction_rate: float = 1.0
@export var scale_correction_rate: float = 1.0
@export var skew_correction_rate: float = 1.0
@export var original: Node2D = null
@export var alien: Alien

@onready var chase_offset: float = randf_range(min_chase_offset, max_chase_offset)


func _ready() -> void:
    if original != null:
        global_transform = Transform2D(original.global_transform)
        global_scale = Vector2.ONE * 0.08


func _process(delta: float) -> void:
    var chase_target := alien.global_position.move_toward(global_position, chase_offset)
    flip_h = alien.global_position.x - global_position.x < 0.0
    global_position = _delta_interp(global_position, chase_target, delta, chase_rate)
    rotation = _delta_interp(rotation, 0.0, delta, rotation_correction_rate)
    scale = _delta_interp(scale, Vector2.ONE * 0.07, delta, scale_correction_rate)
    skew = _delta_interp(skew, 0.0, delta, skew_correction_rate)


## Interpolate proportionally to distance. Like lerp, but stable over varying deltatime.
## from and to may both be floats or vectors.
func _delta_interp(from, to, delta: float, rate: float):
    return to + (from - to)*exp(-rate*delta)
