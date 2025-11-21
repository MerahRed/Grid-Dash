extends CharacterBody2D

# Refrences
@onready var game: Node2D = $".."

const SPEED := 64.0

# Swipe settings
const SWIPE_LENGTH := 50.0
var swiping := false
var start_pos := Vector2()
var cur_pos := Vector2()

var characters = {}

var current_character = 0

#0- default
#1- soul
#2- orb

# For smooth movement
var target_position := Vector2()

func _ready() -> void:
	target_position = position



func _physics_process(delta: float) -> void:
	handle_input()
	handle_swipe()
	handle_limit()

	# Smoothly interpolate toward the target position
	position = position.lerp(target_position, 20.0 * delta)

	handle_characters()



func handle_input() -> void:
	if Input.is_action_just_pressed("ui_left"):
		$AnimationPlayer.play("move")
		target_position.x -= SPEED
	elif Input.is_action_just_pressed("ui_right"):
		$AnimationPlayer.play("move")
		target_position.x += SPEED
	elif Input.is_action_just_pressed("ui_up"):
		$AnimationPlayer.play("move")
		target_position.y -= SPEED
	elif Input.is_action_just_pressed("ui_down"):
		$AnimationPlayer.play("move")
		target_position.y += SPEED


func handle_swipe() -> void:
	if Input.is_action_just_pressed("press"):
		$AnimationPlayer.play("move")
		swiping = true
		start_pos = get_global_mouse_position()

	elif Input.is_action_pressed("press") and swiping:
		cur_pos = get_global_mouse_position()

	elif Input.is_action_just_released("press") and swiping:
		cur_pos = get_global_mouse_position()
		var diff := cur_pos - start_pos
		var dist := diff.length()

		if dist >= SWIPE_LENGTH:
			# Detect swipe direction even if user lifted quickly
			if abs(diff.x) > abs(diff.y):
				if diff.x > 0:
					target_position.x += SPEED
				else:
					target_position.x -= SPEED
			else:
				if diff.y > 0:
					target_position.y += SPEED
				else:
					target_position.y -= SPEED

		swiping = false



func handle_limit() -> void:
	# Apply your original border logic
	if target_position.x >= 608:
		target_position.x = 608 - 64
	elif target_position.x <= 352:
		target_position.x = 352 + 64

	if target_position.y <= 224:
		target_position.y = 224 + 64
	elif target_position.y >= 480:
		target_position.y = 480 - 64



func handle_characters():
	if current_character == 0:
		$characters/default.visible = true
		$characters/Soul.visible = false
	elif current_character == 1: 
		$characters/default.visible = false
		$characters/Soul.visible = true
