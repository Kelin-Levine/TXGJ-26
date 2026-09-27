class_name TutorialCloser
extends Node

# var debugCounterNum: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	# debug code to close tutorial after so many frames
	#debugCounterNum += 1
	#print(debugCounterNum)
	#if (debugCounterNum > 200):
		#close_tutorial()

func close_tutorial() -> void:
	queue_free()
