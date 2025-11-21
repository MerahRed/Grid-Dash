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
@onready var money: Label = $"../CanvasLayer/money"

var main_menu = preload("res://scenes/main_menu.tscn")

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
	money.text = "$ " + str(coin)
	#characters display
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
					if now == 1:
						animation_player.play("play")
					elif now != 0:
						change_scene()



func handle_input() -> void:
	if Input.is_action_just_pressed("ui_up"):
		$AnimationPlayer.play("move")
		target_position.y -= SPEED
		if now == 1:
			animation_player.play("play")
		elif now != 0:
			change_scene()
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
	if area.name == "back":
		animation_player.play("select play")
		now = 1
	if area.name == "default":
		now = 2
	if area.name == "heart":
		now = 3

func change_scene():
	var tween = create_tween()
	if now == 1:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	if now == 2:
		current_character = 0
		tween.tween_property($"../default/default", "position", Vector2($"../default/default".position.x, $"../default/default".position.y - 100), 0.2)
		tween.tween_property($"../default/default", "position", Vector2($"../default/default".position.x, $"../default/default".position.y), 0.2)
		save()
	if now == 3:
		if characters["soul"] == false and coin >= 30:
			coin -= 30
			characters["soul"] = true
			tween.tween_property($"../Shop/heart", "position", Vector2($"../Shop/heart".position.x, $"../Shop/heart".position.y - 100), 0.2)
			tween.tween_property($"../Shop/heart", "position", Vector2($"../Shop/heart".position.x, $"../Shop/heart".position.y), 0.2)
			current_character = 1
			save()
		elif characters["soul"] == true:
			tween.tween_property($"../Shop/heart", "position", Vector2($"../Shop/heart".position.x, $"../Shop/heart".position.y - 100), 0.2)
			tween.tween_property($"../Shop/heart", "position", Vector2($"../Shop/heart".position.x, $"../Shop/heart".position.y), 0.2)
			current_character = 1
			save()



func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "back":
		if now == 1:
			now = 0
			animation_player.play("out play")
	if area.name == "default":
		if now == 2:
			now = 0
	if area.name == "heart":
		if now == 3:
			now = 0



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "select play":
		animation_player.play("idle")

func save():
	game_data = { "coin": coin,"highscore": highscore, "characters": characters,  "current_character": current_character}
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(var_to_str(game_data))
		file.close()

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
