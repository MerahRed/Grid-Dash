extends CharacterBody2D

# 9eon life (lobby song)

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

var gamemode = preload("res://scenes/gamemode_selection.tscn")
var shop = preload("res://scenes/shop.tscn")

var now = 0

#Saving system
var game_data = {}
var config_file = ConfigFile.new()
var save_path = "user://save_game.dat"
var characters = {
	"default" : true,
	"soul" : false
}
var current_character = 0
#0- default
#1- soul
#2- orb


var coin = 0
var highscore = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_save()
	target_position = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_swipe()
	handle_input()
	position = position.lerp(target_position, 20.0 * delta)
	#display character
	handle_characters()

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
					if now != 0:
						animation_player.play("change scene")



func handle_input() -> void:
	if Input.is_action_just_pressed("ui_up"):
		$AnimationPlayer.play("move")
		target_position.y -= SPEED
		if now != 0:
			animation_player.play("change scene")
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
	if area.name == "shop":
		animation_player.play("select shop")
		now = 2

func change_scene():
	if now == 1:
		get_tree().change_scene_to_packed(gamemode)
	if now == 2:
		get_tree().change_scene_to_packed(shop)


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "play":
		if now == 1:
			now = 0
			animation_player.play("out play")
	if area.name == "shop":
		if now == 2:
			now = 0
			animation_player.play("out shop")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "select play":
		animation_player.play("idle play")


func load_save():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		game_data = str_to_var(file.get_as_text())
		file.close()
		#print(game_data)
		coin = game_data.coin
		highscore = game_data.highscore
		characters = game_data.characters
		current_character = game_data.current_character
	else:
		print("no save file yet")

func handle_characters():
	if current_character == 0:
		$characters/default.visible = true
		$characters/Soul.visible = false
	elif current_character == 1: 
		$characters/default.visible = false
		$characters/Soul.visible = true

func save():
	game_data = { "coin": coin,"highscore": highscore, "characters": characters,  "current_character": current_character}
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(var_to_str(game_data))
		file.close()

func _on_button_pressed() -> void:
	coin = 0
	characters = {
	"default" : true,
	"soul" : false
}
	highscore = 0
	current_character = 0
	save()
	print(game_data)


func _on_button_2_pressed() -> void:
	coin += 30
	save()
