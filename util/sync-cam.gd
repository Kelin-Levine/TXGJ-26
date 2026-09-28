class_name SyncCam
extends Camera3D

@export var based_on: Camera2D


func _process(_delta: float) -> void:
	var pos := based_on.global_position
	global_position = Vector3(pos.x/ 1000, -pos.y/1000, global_position.z)
