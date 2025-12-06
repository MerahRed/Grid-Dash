extends Node2D


var SPEED = 8
const JUMP_VELOCITY = -400.0
var target = Vector2()

@onready var game: Node2D = $"../.."
@onready var gameover: Node2D = $"../../over screen"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func _physics_process(delta: float) -> void:
	look_at(target)
	position += target * Vector2(SPEED,SPEED)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "player":
		animation_player.play("game over")
		$"../../spawner".queue_free()
		area.get_parent().queue_free()
		self.queue_free()
		
