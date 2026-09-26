class_name TitleButtonSettings
extends Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "GREEN"
	pressed.connect(_buttton_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _buttton_pressed() -> void:
	# print("green button pressed") # debug code
	greenify()

func greenify() -> void:
	Greenify.visible = !Greenify.visible
