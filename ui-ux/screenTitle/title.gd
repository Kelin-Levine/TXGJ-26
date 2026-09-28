extends Control

@export var button: TextureButton
@export var game: PackedScene # attach whatever scene is for the game
@export var scoreBoard: PackedScene # attach whatever scene is for the scoreboard (unless later attached to the game, then delete)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.pressed.connect(play_button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func play_button_pressed():
	hide()
	get_tree().root.add_child(game.instantiate())
	print("loaded game")
	get_tree().root.add_child(scoreBoard.instantiate()) # note: starting the game is a seperate process from starting up the score system; may alter later
	print("loaded score")
