extends CharacterBody2D


const SPEED = 100.0

var Directions
var currentDirection
var onColisionDirection
var nextDirection


func _ready():
	Directions = {
		"up": {
			"vector": Vector2(0, -1),
			"rays": [$to_up_left, $to_up_right],
			"ortogonal": ["left", "right"],
			"oposite": "down"
		},
		"down":{
			"vector": Vector2(0, 1),
			"rays": [$to_down_left, $to_down_right],
			"ortogonal": ["left", "right"],
			"oposite": "up"
		},
		"left":{
			"vector": Vector2(-1, 0),
			"rays": [$to_left_up, $to_left_down],
			"ortogonal": ["up", "down"],
			"oposite": "right"
		},
		"right":{
			"vector": Vector2(1, 0),
			"rays": [$to_right_up, $to_right_down],
			"ortogonal": ["up", "down"],
			"oposite": "left"
		}
	}
	
	currentDirection = Directions.right


func takeDirection(dir, nowOrNext):
	var newDirection = Directions[dir]
	
	if !newDirection:
		return

	var rays = newDirection.rays

	var cannotGo = rays[0].is_colliding() || rays[1].is_colliding()
	
	if !cannotGo:
		nextDirection = null
		onColisionDirection = currentDirection
		currentDirection = newDirection
		return true

	if nowOrNext:
		nextDirection = newDirection
	
	return false

func _input(event):
	var newDirection
	if event.is_action_pressed("ui_left"):
		takeDirection("left", true)
	elif event.is_action_pressed("ui_right"):
		takeDirection("right", true)
	elif event.is_action_pressed("ui_down"):
		takeDirection("down", true)
	elif event.is_action_pressed("ui_up"):
		takeDirection("up", true)


func _physics_process(delta):
	if (!currentDirection):
		return
	
	if (currentDirection.rays[0].is_colliding() || currentDirection.rays[1].is_colliding()):
		currentDirection.ortogonal.shuffle()
		for (key in currentDirection.ortogonal):
			
			
	
	if (nextDirection):
		var rays = nextDirection.rays
		var cannotGo = rays[0].is_colliding() || rays[1].is_colliding()
		
		if cannotGo:
			pass
		else:
			currentDirection = nextDirection	
	
	velocity.x = currentDirection.vector.x * SPEED
	velocity.y = currentDirection.vector.y * SPEED

	move_and_slide()
