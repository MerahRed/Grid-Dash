extends Node2D

@onready var game: Node2D = $".."

@export var obs = preload("res://scenes/Bosses/hammer/hammer.tscn")
@onready var timer: Timer = $"../obs_Timer"

const coin = preload("res://scenes/coin.tscn")
@onready var coin_timer: Timer = $"../coin_Timer"

@onready var show_warning: CheckButton = $"../ShowWarning"

#difficulty
var current_speed = 8
var obs_cooldown = 3

func spawn_obs():
	var obstacle = obs.instantiate()
	obstacle.SPEED = current_speed
	var pos = Vector2()
	pos.x = randi_range(1,4)
	obstacle.rotation_degrees = 180
	if pos.x == 1:
		pos.x = 1200
		pos.y = randi_range(1,0)
		if pos.y == 1:
			pos.y = 320
		else:
			pos.y = 384
		obstacle.target = Vector2(-1,0)
	elif pos.x == 2:
		pos.x = -500
		pos.y = randi_range(1,0)
		obstacle.rotation_degrees = 0
		if pos.y == 1:
			pos.y = 320
		else:
			pos.y = 384
		obstacle.target = Vector2(1,0)
	elif pos.x == 3:
		pos.x = 448
		pos.y = randi_range(1,0)
		if pos.y == 1:
			pos.y = -500
			obstacle.target = Vector2(0,1)
			obstacle.rotation_degrees = 90
		else:
			pos.y = 1000
			obstacle.target = Vector2(0,-1)
			obstacle.rotation_degrees = -90
	elif pos.x == 4:
		pos.x = 512
		pos.y = randi_range(1,0)
		if pos.y == 1:
			pos.y = -500
			obstacle.target = Vector2(0,1)
			obstacle.rotation_degrees = 90
		else:
			pos.y = 1000
			obstacle.target = Vector2(0,-1)
			obstacle.rotation_degrees = -90
	obstacle.global_position = pos
	obstacle.get_node("Warning").visible = show_warning.button_pressed
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
