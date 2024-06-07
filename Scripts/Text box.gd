extends MarginContainer

@onready var label = $MarginContainer/Text
@onready var timer = $Timer
@onready var animation = $AnimationPlayer

const  MAX_WIDTH = 224
@onready var text_box = $".."
@export var text := ""
var textIndex = 0

var letterTime = .1
var spaceTime = letterTime*2
var ponctuationTime = letterTime/2

signal finishedDisplay()


func _ready():
	text = text_box.text
	animation.play("entry")
	await animation.animation_finished
	display(text)

func display(t):
	text = t
	label.text = text
	
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y
	global_position.y -= size.y - 8
	
	label.text = ""
	displayLetter()

func displayLetter():
	label.text += text[textIndex]
	print(text[textIndex])
	textIndex+=1
	if textIndex >= text.length():
		finishedDisplay.emit()
		return
	match text[textIndex]:
		"!", ".", ",", "?":
			timer.start(ponctuationTime)
		" ":
			timer.start(spaceTime)
		_:
			timer.start(letterTime)
		


func _on_timer_timeout():
	print("timeout")
	displayLetter()
