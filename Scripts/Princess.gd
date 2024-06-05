extends Area2D

@onready var game_manager = %GameManager
@onready var sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	game_manager.princess = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if position.x < game_manager.player.position.x: sprite.flip_h = false
	else: sprite.flip_h = true


func _on_body_entered(_body):
	get_tree().reload_current_scene()
