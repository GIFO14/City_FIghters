extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 20
const SPEED = 200
const JUMP_HEIGHT = -500

var motion = Vector2()

func _physics_process(delta):
	motion.y += 10 #GRAVITY

	if Imput.is_action_pressed("ui_d"):
		motion.x = 100#SPEED

	elif Input.is_action_pressed("ui_a"):
		motion.x = -100#-SPEED

	else:
		motion.x = 0
	
	#if is_on_floor():
	#	if Input.is_action_just_pressed("ui_w"):
	#		motion.y = JUMP_HEIGHT
		
	move_and_slide(motion)
	pass