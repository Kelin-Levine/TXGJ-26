class_name GlowingLight
extends OmniLight3D

@export var max_atten: float
@export var min_atten: float
@export var rate: float = 1.0

var going_up = true


func _ready() -> void:
	omni_attenuation = min_atten


func _process(delta: float) -> void:
	if going_up:
		if omni_attenuation < max_atten:
			omni_attenuation += delta * rate
		else:
			going_up = false
	else:
		if omni_attenuation > min_atten:
			omni_attenuation -= delta * rate
		else:
			going_up = true
