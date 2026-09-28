class_name Isotope
extends RapierRigidBody2D

@export var fall_speed: float = 1.0
@export var smack_height: float = 0.0
@export var smack_velocity: float = 1200.0
@export var warn_color: Color
@export var lose_color: Color

@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var warn_canvas: CanvasLayer = $WarningCanvas
@onready var warn_color_rect: ColorRect = $WarningCanvas/WarningColor
@onready var lose_screen: Control = $WarningCanvas/LoseScreen

var smacked: bool = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	smack()
	do_warning_flash()

func _physics_process(_delta: float) -> void:
	if smacked:
		linear_velocity.y = fall_speed * -15.0
		if global_position.y < smack_height:
			unsmack()
	else:
		#linear_velocity = linear_velocity.limit_length(fall_speed)
		linear_velocity.y = minf(linear_velocity.y, fall_speed)


func _on_body_entered(body: Node) -> void:
	if body is Alien or body is ChainLink:
		smack()  # TODO: play smack animation
	elif body is IsotopeDestroyer:
		do_game_end_flash()


func _modulate_color_vis_up(steps: int) -> void:
	for j in range(steps):
		warn_color_rect.modulate = Color(1.0, 1.0, 1.0, (j+1.0)/steps)
		await get_tree().physics_frame  # not smooth but consistent over time at least


func _modulate_color_vis_down() -> void:
	for j in range(30):
		warn_color_rect.modulate = Color(1.0, 1.0, 1.0, (29-j)/30.0)
		await get_tree().physics_frame  # not smooth but consistent over time at least


func do_warning_flash() -> void:
	warn_color_rect.color = warn_color
	warn_canvas.visible = true
	for i in range(3):
		await _modulate_color_vis_up(30)
		await _modulate_color_vis_down()
	warn_canvas.visible = false


func do_game_end_flash() -> void:
	Engine.time_scale = 0.5
	warn_color_rect.color = lose_color
	warn_canvas.visible = true
	await _modulate_color_vis_up(180)
	# get_tree().paused = true
	lose_screen.visible = true
	warn_color_rect.visible = false
	Engine.time_scale = 1.0
	# TODO: remember to unpause the game when restart button is clicked


func smack() -> void:
	smacked = true
	collision_shape.disabled = true
	linear_velocity.x = randf_range(-smack_velocity, smack_velocity)


func unsmack() -> void:
	smacked = false
	collision_shape.disabled = false
