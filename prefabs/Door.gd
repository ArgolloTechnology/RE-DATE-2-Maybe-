extends AnimatedSprite2D


var isOpen = false
@onready var collision_shape_2d = $StaticBody2D/CollisionShape2D
@onready var timer = $Timer

func _on_area_2d_body_entered(_body):
	if !isOpen: open()
	
func _process(delta):
	if timer.is_stopped() and isOpen: collision_shape_2d.set_deferred("disabled",true)

func open():
	isOpen = true
	timer.start()
	play("default")
	print(collision_shape_2d.disabled)
	
