extends Area2D
@onready var animation_player = $AnimationPlayer

func _on_body_entered(_body):
	print("+1")
	animation_player.play("pickup")
