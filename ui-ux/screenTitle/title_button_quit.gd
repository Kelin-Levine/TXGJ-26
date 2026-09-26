class_name TitleButtonQuit
extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "QUIT"
	pressed.connect(_buttton_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _buttton_pressed() -> void:
	print("quit button pressed") # debug code
	get_tree().quit()
