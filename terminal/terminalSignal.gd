class_name Terminal
extends RapierArea2D

@export var initially_active: bool = false
var isActive: bool
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var label: Label = $Label
@onready var label_timer: Timer = $LabelTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label_timer.timeout.connect(hide_label)
	body_entered.connect(_on_body_entered)
	if initially_active:
		activate_terminal() # all terminals activate immedietally at the moment
	else:
		deactivate_terminal()

func _on_body_entered(body: Node) -> void:
	# emits signal that a terminal was touched, then makes self inactive
	if body is Alien and isActive:
		#print("debug test collide with terminal")
		# put other code here
		deactivate_terminal()
		var msg: String = get_tree().get_first_node_in_group(&"UpgradeManager").grant_upgrade()
		label.text = msg
		label.visible = true
		label_timer.start()

func hide_label():
	label.visible = false

func activate_terminal():
	isActive = true
	sprite.play(&"on")

func deactivate_terminal():
	isActive = false
	sprite.play(&"off")
