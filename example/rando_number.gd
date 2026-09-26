class_name RandoNumber
extends Label

@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.timeout.connect(_on_timeout)


func _on_timeout() -> void:
	text = str(randi_range(0, 10))
