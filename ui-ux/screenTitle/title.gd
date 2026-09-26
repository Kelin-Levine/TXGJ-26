extends Control

@export var button: Button
@export var game: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.pressed.connect(play_button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_button_pressed():
	hide()
	get_tree().root.add_child(game.instantiate())
