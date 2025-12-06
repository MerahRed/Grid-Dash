extends Node2D


var SPEED = 0
const JUMP_VELOCITY = -400.0
var player = Vector2()
var target = Vector2()
var rotate = 0

@onready var game: Node2D = $"../.."
@onready var gameover: Node2D = $"../../over screen"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func _ready() -> void:
	rotate = global_position.angle_to_point(player)
	rotate = rotate * (180 / PI)
	if  rotate < -90 or rotate > 90:
		scale.x = -1
		rotate += 180
	else:
		scale.x = 1
		
	rotation_degrees =  randf_range(180,360)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(self,"rotation_degrees",rotate,0.6)
	tween.connect("finished", Callable(self, "_on_tween_finished"))

func _on_tween_finished():
	if  rotate < -90 or rotate > 90:
		SPEED = -500
	else:
		SPEED = 500
	$Sprite/Warning.visible = false

func _physics_process(delta: float) -> void:
	
	# Get the direction vector from the current rotation (in radians)
	# The magnitude of this vector is 1 (normalized)
	var direction_vector = Vector2.from_angle(rotation)
	
	# Calculate the displacement for this frame
	var movement_amount = direction_vector * SPEED * delta
	
	# Update the node's position directl
	$bullet.global_position += movement_amount

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "player":
		animation_player.play("game over")
		$"../../spawner".queue_free()
		area.get_parent().queue_free()
		self.queue_free()
		


func _on_timer_timeout() -> void:
	queue_free()
