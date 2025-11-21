extends CharacterBody2D

const SPEED := 220.0

# Swipe settings
const SWIPE_LENGTH := 50.0
var swiping := false
var start_pos := Vector2()
var cur_pos := Vector2()

# For smooth movement
var target_position := Vector2()

@onready var current: ColorRect = $current
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

var play = preload("res://scenes/game.tscn")

var now = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_position = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_swipe()
	handle_input()
	position = position.lerp(target_position, 20.0 * delta)


func handle_swipe() -> void:
	if Input.is_action_just_pressed("press"):
		swiping = true
		start_pos = get_global_mouse_position()

	elif Input.is_action_pressed("press") and swiping:
		cur_pos = get_global_mouse_position()

	elif Input.is_action_just_released("press") and swiping:
		cur_pos = get_global_mouse_position()
		var diff := cur_pos - start_pos
		var dist := diff.length()

		if dist >= SWIPE_LENGTH:
			$AnimationPlayer.play("move")
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
					if now == 1:
						animation_player.play("play")



func handle_input() -> void:
	if Input.is_action_just_pressed("ui_up"):
		$AnimationPlayer.play("move")
		target_position.y -= SPEED
		if now == 1:
			animation_player.play("play")
	elif Input.is_action_just_pressed("ui_down"):
		$AnimationPlayer.play("move")
		target_position.y += SPEED
	if Input.is_action_just_pressed("ui_left"):
		$AnimationPlayer.play("move")
		target_position.x -= SPEED
	elif Input.is_action_just_pressed("ui_right"):
		$AnimationPlayer.play("move")
		target_position.x += SPEED


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "play":
		animation_player.play("select play")
		now = 1
	if area.name == "shooter":
		animation_player.play("select shooter")
		now = 2

func change_scene():
	if now == 1:
		get_tree().change_scene_to_packed(play)


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "play":
		if now == 1:
			now = 0
			animation_player.play("out play")
	if area.name == "shooter":
		if now == 2:
			now = 0
			animation_player.play("out shooter")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "select play":
		animation_player.play("idle")
