extends Area2D

@onready var game: Node2D = $".."

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "player":
		game.coin += 1
	self.queue_free()
