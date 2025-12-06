extends Node2D

@onready var game: Node2D = $".."

@export var obs = preload("res://scenes/obs.tscn")
@onready var timer: Timer = $"../obs_Timer"

const coin = preload("res://scenes/coin.tscn")
@onready var coin_timer: Timer = $"../coin_Timer"

@onready var show_warning: CheckButton = $"../ShowWarning"

#difficulty
var current_speed = 800
var obs_cooldown = 3

func spawn_obs():
	var obstacle = obs.instantiate()
#	obstacle.SPEED = current_speed
	var pos = Vector2()
	pos.x = randi_range(150,800)
	pos.y = randi_range(0,700)
	while pos.x > 270 && pos.x < 700:
		pos.x = randi_range(0,700)
	obstacle.global_position = pos
	obstacle.player = $"../player".global_position
	obstacle.get_node("Sprite/Warning").visible = show_warning.button_pressed
	add_child(obstacle)


func _on_timer_timeout() -> void:
	spawn_obs()
	timer.wait_time = obs_cooldown
	timer.start()
	game.score += 1
	#increasing the difficulty
	obs_cooldown -= 0.05
	current_speed += 0.05
	#limiting the difficulty
	if obs_cooldown < 1:
		obs_cooldown = 1
	if current_speed > 12:
		current_speed = 12


func spawn_coin():
	var coins = coin.instantiate()
	coins.global_position.x = 416.0 + (64 * randi_range(0,2))
	coins.global_position.y = 288.0 + (64 * randi_range(0,2))
	get_parent().add_child(coins)


func _on_coin_timer_timeout() -> void:
	spawn_coin()
	coin_timer.start()
