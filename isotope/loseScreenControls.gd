extends Control

@export var buttonPlay: TextureButton
@export var buttonTitle: TextureButton
@export var game: PackedScene # attach whatever scene is for the game
@export var scoreBoard: PackedScene # attach whatever scene is for the scoreboard (unless later attached to the game, then delete)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#buttonPlay.pressed.connect(play_button_pressed)
	buttonTitle.pressed.connect(title_button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

#currently broken
#func play_button_pressed():
	#get_parent().get_parent().hide()
	#game = 
	#get_tree().root.add_child(game.instantiate())
	## print("loaded game") debug
	## get_tree().root.add_child(scoreBoard.instantiate()) # note: starting the game is a seperate process from starting up the score system; may alter later
	## print("loaded score") debug
	#get_tree().root.get_child(-2).queue_free()

func title_button_pressed():
	get_tree().root.get_child(2).get_child(0).show()
	get_tree().root.get_child(-1).queue_free()
