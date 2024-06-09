extends CharacterBody2D

#region Variables

@onready var sprite = $Sprite

#region Sounds

@onready var jump = $Sounds/Jump
@onready var hurt = $Sounds/Hurt
#endregion

@onready var walk_dust = $Particles/WalkDust
@onready var jump_dust = $Particles/JumpDust

const SPEED = 100.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var alive = true 
var dying = false

#endregion
@onready var game_manager = %GameManager

var levelEnded = false
var canMove = true
var canJump = true
@onready var animation_player = $Ending/AnimationPlayer

const dashSpeed = 160
@onready var dashTimer = $Timer
var canDash = true
var dashDir = 1

func _ready():
	game_manager.player = self
	if position.x < game_manager.princess.position.x: sprite.flip_h = false
	else: sprite.flip_h = true
func _process(delta):
	if levelEnded:
		sprite.play("idle")
		canMove = false
		canJump = false
		animation_player.play("End")
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		jump_dust.emitting = false
	if alive: 

		# Handle jump.
		if Input.is_action_just_pressed("Jump") and is_on_floor() and canJump:
			jump_dust.emitting = true
			velocity.y = JUMP_VELOCITY
			jump.play()

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("Left", "Right")
		if !Input.is_action_just_pressed("dash"):
			if is_on_floor():
				if direction > 0: 
					dashDir = 1
					sprite.flip_h = false
				elif direction < 0: 
					dashDir = -1
					sprite.flip_h = true
				else: sprite.play("idle")
			else:
				sprite.play("Jump")
			if canMove:
				if direction:
					velocity.x = direction * SPEED
					sprite.play("Run")
					if is_on_floor(): walk_dust.emitting = true
					else: walk_dust.emitting = false
					
				else:
					velocity.x = move_toward(velocity.x, 0, SPEED)
		else:
			dash(dashDir)

	else: 
		canMove = false
		if !dying: 
			dying = true
			hurt.play()
		sprite.play("Death")
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
func SetMoviment(v : bool):
	canMove = v
	canJump = v
	print(v)
func nextLevel():
	var levelName = get_tree().current_scene.name
	print(levelName)
	levelName = levelName.split("_", true,2)
	print(levelName[0])
	print(levelName[1])
	get_tree().change_scene_to_file("res://cenas/Level_"+ str(int(levelName[1])+1)+".tscn")
	
func dash(dir):
	if canDash:
		dashTimer.start()
		SetMoviment(false)
		velocity.x = dashSpeed * dir
		await dashTimer.is_stopped()
		SetMoviment(true)
