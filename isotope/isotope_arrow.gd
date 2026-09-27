class_name IsotopeArrow
extends Sprite2D

@export var isotope: Node2D
@onready var distFromCentre: float = get_viewport().get_visible_rect().size.y * 0.4
@onready var amountOffScreen: float = distFromCentre / get_viewport().get_visible_rect().size.y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# pull position of camera and isotope
	var isotopePosition := Vector2(get_parent().global_position.x, get_parent().global_position.y)
	var cameraPosition := get_viewport().get_camera_2d().get_screen_center_position() 
	var cameraSize := get_viewport().get_visible_rect().size
	var relativePosition = global_position - isotopePosition

	# print(relativePosition) #debug code
	# print(cameraSize) #debug code
	
	#hide if within view of camera
	if (abs(relativePosition.x) < cameraSize.x * amountOffScreen && abs(relativePosition.y) < cameraSize.y * amountOffScreen):
		hide()
	else:
		show()
	
	# determine angle from centre of camera view to isotope
	global_position = cameraPosition
	var angleVector := cameraPosition.direction_to(isotopePosition)
	# print(angleVector) # debug code
	
	global_position += angleVector * distFromCentre
	rotation = angleVector.angle()
	
