class_name Terminal
extends Area2D

var isActive: bool
@onready var spriteActive := $spriteActive
@onready var spriteInactive := $spriteInactive

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	activate_terminal() # all terminals activate immedietally at the moment


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var colliding := get_overlapping_bodies()
	for body in colliding:
		_on_body_entered(body)

func _on_body_entered(body: Node) -> void:
	# emits signal that a terminal was touched, then makes self inactive
	if body.is_in_group("grdfhgfg") && isActive:
		print("debug test collide with terminal")
		# put other code here
		deactivate_terminal()
	pass

func activate_terminal():
	isActive = true
	spriteActive.visible = true
	spriteInactive.visible = false

func deactivate_terminal():
	isActive = false
	spriteInactive.visible = true
	spriteActive.visible = false
