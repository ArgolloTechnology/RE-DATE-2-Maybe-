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
	var levelName = get_tree().current_scene.name
	print(levelName)
	levelName = levelName.split("_", true,2)
	print(levelName[0])
	print(levelName[1])
	get_tree().change_scene_to_file("res://cenas/Level_"+ str(int(levelName[1])+1)+".tscn")
