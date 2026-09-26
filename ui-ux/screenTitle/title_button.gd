class_name TitleButton
extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var button = Button.new()
	button.text = "PLAY"
	button.pressed.connect(_button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _button_pressed():
	ScoreTicker.add_score(10)
