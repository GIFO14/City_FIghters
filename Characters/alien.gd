extends Area2D
var posicio = Vector2()
var velocitat = 400
const JUMP_SPEED = -1000

func _ready():
	position.y = 580
	position.x = 150
	
func _process(delta):
	posicio = Vector2()
	
	if Input.is_action_pressed("ui_a"):
		posicio.x -=1
		
	if Input.is_action_pressed("ui_d"):
		posicio.x +=1
	
	if Input.is_action_pressed("ui_w"):
		posicio.y -= 1
		
	if posicio.length() > 0:
		posicio = posicio.normalized()*velocitat
	position += posicio * delta 
		
func _timer(t):
	t.set_wait_time(3)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	return t