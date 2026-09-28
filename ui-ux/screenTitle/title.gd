extends Control

@export var buttonPlay: TextureButton
@export var buttonTitle: TextureButton
@export var audioPlayer: AudioStreamPlayer
@export var game: PackedScene # attach whatever scene is for the game
@export var scoreBoard: PackedScene # attach whatever scene is for the scoreboard (unless later attached to the game, then delete)

@export var loseScreen: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visibility_changed.connect(_update_music)
	buttonPlay.pressed.connect(play_button_pressed)
	#buttonTitle.pressed.connect(title_button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func play_button_pressed():
	hide()
	get_tree().root.add_child(game.instantiate())
	# print("loaded game") debug
	# get_tree().root.add_child(scoreBoard.instantiate()) # note: starting the game is a seperate process from starting up the score system; may alter later
	# print("loaded score") debug

func title_button_pressed():
	show()

func _update_music() -> void:
	if is_visible_in_tree():
		if not audioPlayer.playing:
			audioPlayer.play()
	else:
		audioPlayer.stop()
