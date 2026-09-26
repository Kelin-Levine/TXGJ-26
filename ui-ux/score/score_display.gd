class_name ScoreDisplay
extends Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_text("Score:")	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	set_text(" Score:\n" + (str) (ScoreTicker.score))
