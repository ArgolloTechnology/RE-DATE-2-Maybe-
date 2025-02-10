extends Node2D
var speed = 30
@onready var sprite = $Sprite

@onready var ray_cast_2d_r = $"RayCast2D R"
@onready var ray_cast_2d_l = $"RayCast2D L"
@onready var ray_cast_2d_r_2 = $"RayCast2D R2"
@onready var ray_cast_2d_l_2 = $"RayCast2D L2"

@onready var collider = $"Kill Zone/CollisionShape2D"

@onready var player_detection = $"Player detection"

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var canMove = 0

var dir = -1
func _ready():
	sprite.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if canMove:
		if ray_cast_2d_r.is_colliding() || !ray_cast_2d_r_2.is_colliding():
			dir = -1
		if ray_cast_2d_l.is_colliding() || !ray_cast_2d_l_2.is_colliding():
			dir = 1
		_flip(dir)
		position.x+=speed * delta * dir

func _flip(d):
	if d > 0: sprite.flip_h = false
	else: sprite.flip_h = true


func _on_player_detection_body_entered(body):
	if body.position.x < position.x: dir = -1
	else: dir = 1
	_flip(dir)
	if !canMove:
		sprite.visible = true
		sprite.play("Spawn")
		await sprite.animation_finished
		canMove = true
		sprite.play("Idle")
