extends CharacterBody2D

#region Variables

@onready var sprite = $Sprite

#region Sounds
@onready var jump = $Sounds/Jump
@onready var hurt = $Sounds/Hurt
@onready var dashSound = $Sounds/dash
#endregion

#region Effects
@onready var walk_dust = $Effects/WalkDust
@onready var jump_dust = $Effects/JumpDust
@onready var trail_2d = $Effects/Trail2D
#endregion

const SPEED = 100.0
const JUMP_VELOCITY = -300.0
const DASH_SPEED = 315

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var alive = true 
var dying = false
var levelEnded = false
var canMove = true
var canJump = true
var canDash = true
var dashDir = 1
var dashing = false

@onready var game_manager = %GameManager
@onready var animation_player = $Ending/AnimationPlayer
@onready var dashTimer = $Timer

func _ready():
	trail_2d.visible = false
	game_manager.player = self
	sprite.flip_h = position.x >= game_manager.princess.position.x

func _process(delta):
	if levelEnded:
		handle_level_end()
	
func _physics_process(delta):
	if alive:
		apply_gravity(delta)
		handle_movement()
	else:
		handle_death()
	move_and_slide()

func handle_level_end():
	dashing = false
	velocity.x = 0
	sprite.play("idle")
	canMove = false
	canJump = false
	animation_player.play("End")

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		jump_dust.emitting = false

func handle_movement():
	if Input.is_action_just_pressed("Jump") and is_on_floor() and canJump:
		jump_dust.emitting = true
		velocity.y = JUMP_VELOCITY
		jump.play()

	var direction = Input.get_axis("Left", "Right")
	if !Input.is_action_just_pressed("dash") and !dashing:
		if is_on_floor():
			flip(direction)
		else:
			sprite.play("Jump")

		if canMove:
			if direction:
				velocity.x = direction * SPEED
				sprite.play("Run")
				walk_dust.emitting = is_on_floor()
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		if canDash:
			perform_dash(direction)

func handle_death():
	canMove = false
	if not dying:
		dying = true
		hurt.play()
	sprite.play("Death")
	velocity.x = move_toward(velocity.x, 0, SPEED)

func perform_dash(direction):
	if canDash:
		trail_2d.visible = true
		canDash = false
		dashing = true
		dashSound.play()
		sprite.play("dash")
		set_movement(false)
		velocity.x = DASH_SPEED * (direction if direction != 0 else dashDir)
		gravity = 0
		velocity.y = 0
		await sprite.animation_finished
		dashing = false
		canDash = true
		gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
		set_movement(true)
		trail_2d.visible = false

func set_movement(value):
	canMove = value
	canJump = value

func flip(direction):
	if direction > 0:
		dashDir = 1
		sprite.flip_h = false
	elif direction < 0:
		dashDir = -1
		sprite.flip_h = true
	else:
		sprite.play("idle")

func nextLevel():
	var levelName = get_tree().current_scene.name
	levelName = levelName.split("_", true,2)
	var next = get_tree().change_scene_to_file("res://cenas/Level_"+ str(int(levelName[1])+1)+".tscn")
	if next: get_tree().change_scene_to_file("res://cenas/Level_1.tscn") 
