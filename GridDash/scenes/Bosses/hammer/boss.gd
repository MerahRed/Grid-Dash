extends Node2D

@onready var txtscore: Label = $txtscore
@onready var txtcoin: Label = $txtcoin
@onready var txthighscore: Label = $"over screen/txthighscore"
@onready var player: CharacterBody2D = $player

var score = 0
var highscore = 0
var coin = 0

var main_menu = preload("res://scenes/main_menu.tscn")

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_save()
	player.characters = characters
	player.current_character = current_character
	print(game_data)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	txtscore.text = str(score)
	txtcoin.text = "$ " + str(coin)
	txthighscore.text = "Highscore : " + str(highscore)
	if score > highscore:
		highscore = score


func save():
	game_data = { "coin": coin,"highscore": highscore, "characters": characters, "current_character" : current_character}
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


func _on_try_again_pressed() -> void:
	save()
	get_tree().reload_current_scene()

func _on_back_pressed() -> void:
	save()
	$AnimationPlayer.play("back")


func back_to_menu():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
