class_name TitleButtonPlay
extends Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "PLAY"
	pressed.connect(_buttton_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _buttton_pressed() -> void:
	print("play button pressed") # debug code
	change_scene()

func change_scene() -> void:
	pass
